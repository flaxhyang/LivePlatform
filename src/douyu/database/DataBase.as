package douyu.database
{
	import flash.data.SQLConnection;

	import flash.data.SQLStatement;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;

	
	import douyu.vo.InfoData;
	
	public class DataBase extends EventDispatcher
	{
		public static const LINK_DATABASE_COMPLETE:String="link_database_complete";
		
		
		
		private var con:SQLConnection;
//		private var stmt:SQLStatement;
		
		private var topallStmt:SQLStatement;
		
		private var SelectStmt:SQLStatement;
		private var giftYWStmt:SQLStatement;
		
		private var showMVStmt:SQLStatement;
		private var MVcheckStmt:SQLStatement;
		private var MVStmt:SQLStatement;
		
		private var updataPStmt:SQLStatement;
		
		private var leaveWordStmt:SQLStatement;
		
		private var selectTopMVStmt:SQLStatement;
		
		private var playmvStmt:SQLStatement;
		private var getTopmvStmt:SQLStatement;
		
		private var checkContinuityStmt:SQLStatement;
		
		
		private var infodata:InfoData;
		
		
		private const MinContinuityLimit:int=10;//需要连点的 起步鱼丸数 10个= 1000鱼丸
		private const ContinuityStepNum:int=2;//1000鱼丸可连点5首,继续加歌200鱼丸一首、
		public var currContnuityNum:int=0;//点连播的时候查看能连续几首
		
		
		
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

			topallStmt=new SQLStatement();
			topallStmt.sqlConnection = con;
			
			giftYWStmt=new SQLStatement();
			giftYWStmt.sqlConnection=con;
			
			SelectStmt=new SQLStatement();
			SelectStmt.sqlConnection = con;
			
			showMVStmt=new SQLStatement();
			showMVStmt.sqlConnection=con;
			
			MVcheckStmt=new SQLStatement();
			MVcheckStmt.sqlConnection=con;
			
			MVStmt=new SQLStatement();
			MVStmt.sqlConnection=con;
			
			updataPStmt=new SQLStatement();
			updataPStmt.sqlConnection=con;
			
			selectTopMVStmt=new SQLStatement();
			selectTopMVStmt.sqlConnection=con;
			
			playmvStmt=new SQLStatement();
			playmvStmt.sqlConnection=con;
			
			getTopmvStmt=new SQLStatement();
			getTopmvStmt.sqlConnection=con;
			
			checkContinuityStmt=new SQLStatement();
			checkContinuityStmt.sqlConnection=con;
			
			leaveWordStmt=new SQLStatement();
			leaveWordStmt.sqlConnection=con;
			
			this.dispatchEvent(new Event(LINK_DATABASE_COMPLETE));
			trace("连接数据库成功")
		}
		
		private function errorHandler(evt:SQLErrorEvent):void
		{	
			trace("打开数据库失败！");	
		}
		
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