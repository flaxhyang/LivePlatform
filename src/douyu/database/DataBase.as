package douyu.database
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	import douyu.data.InfoData;
	import douyu.data.vo.PlayerData;
	
	
	public class DataBase extends EventDispatcher
	{
		public static const LINK_DATABASE_COMPLETE:String="link_database_complete";
		private var infodata:InfoData;
		private var con:SQLConnection;
		private var topallStmt:SQLStatement;//获取鱼丸榜前10名
		
		

		public function DataBase(target:IEventDispatcher=null)
		{
			super(target);
			infodata=InfoData.instant;
		}
		
		public function openDatabase():void
		{
			var file:File=new File(InfoData.DataBaseURL);
			con = new SQLConnection();	//在 openAsync() 方法调用操作成功完成时调度	
			con.addEventListener(SQLEvent.OPEN, openHandler);	//SQLConnection 对象的异步操作导致错误时调度	
			con.addEventListener(SQLErrorEvent.ERROR, errorHandler); 	
			con.openAsync(file);//异步
//			con.open(file);
		}
		private function openHandler(evt:SQLEvent):void
		{
			this.dispatchEvent(new Event(LINK_DATABASE_COMPLETE));
			trace("连接数据库成功");
			topallStmt=new SQLStatement();
			topallStmt.sqlConnection = con;
		}
		
		private function errorHandler(evt:SQLErrorEvent):void
		{	
			trace("打开数据库失败！");	
		}

		/**
		 * 获取 鱼丸榜 数据
		 * @param num：获取 前几个
		 */	
		public function getTHTopData(num:int):void{
			topallStmt.text = "select * from people order by sumYW desc limit 0,10"; 
			topallStmt.addEventListener(SQLEvent.RESULT, selectResultHandler);
			topallStmt.addEventListener(SQLErrorEvent.ERROR, selectErrorHandler);
			topallStmt.execute(); 
		}
		
		protected function selectResultHandler(event:SQLEvent):void
		{
			topallStmt.removeEventListener(SQLEvent.RESULT, selectResultHandler);
			topallStmt.removeEventListener(SQLErrorEvent.ERROR, selectErrorHandler);
			var result:SQLResult = topallStmt.getResult();
			if ( result.data != null ) 
			{  
				var numResults:int =result.data.length;//有多少条数据
				var tempTopYWVec:Vector.<PlayerData>=new Vector.<PlayerData>();
				for (var i:int = 0; i < numResults; i++)      
				{          
					var row:Object = result.data[i];          
					//					trace("sumYW="+row.sumYW);
					var currsmp:PlayerData=new PlayerData();
					currsmp.id=row.nameid;
					currsmp.nick=row.name;
					currsmp.totleYW=row.sumYW;
					currsmp.THMessage=row.leaveWord;	          
					tempTopYWVec.push(currsmp);     
				}  
				
				infodata.THDatas=tempTopYWVec;
				
			 }	
		}
		
		protected function selectErrorHandler(event:SQLErrorEvent):void
		{
			topallStmt.removeEventListener(SQLEvent.RESULT, selectResultHandler);
			topallStmt.removeEventListener(SQLErrorEvent.ERROR, selectErrorHandler);
		}
		
		//---------------------------------------------------------------------------------------
		private static var _instant:DataBase;
		public static function get instant():DataBase
		{
			if( null == _instant )
			{
				_instant = new DataBase();
			}
			return _instant;
		}
	}
}