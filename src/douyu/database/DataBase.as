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
	import douyu.data.vo.MusicData;
	import douyu.data.vo.PlayerData;
	

	
	
	public class DataBase extends EventDispatcher
	{
		public static const LINK_DATABASE_COMPLETE:String="link_database_complete";
		//
		public static const ADD_YW_COMPLETE:String="add_yw_complete";//操作player data数据完成 
		
		
		
		private var currMd:MusicData;
		
		private var infodata:InfoData;
		private var con:SQLConnection;
		
		private var topallStmt:SQLStatement;//获取鱼丸榜前10名
		private var MVStmt:SQLStatement;//mv 查询
		private var SelectStmt:SQLStatement; //点播人查询
		private var SelectYW:SQLStatement;//送鱼丸人查询
		private var changePlayerStmt:SQLStatement;//修改player data
		private var insertPlayerStmt:SQLStatement;//新加player data
		

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
			
			//查歌
			MVStmt=new SQLStatement();
			MVStmt.sqlConnection=con;
			
			//搜人(点歌人信息)
			SelectStmt=new SQLStatement();
			SelectStmt.sqlConnection = con;
			
			//搜人（送鱼丸人信息）
			SelectYW=new SQLStatement();
			SelectYW.sqlConnection = con;
			
			//修改player data
			changePlayerStmt=new SQLStatement();
			changePlayerStmt.sqlConnection = con;
			
			//新加player 
			insertPlayerStmt=new SQLStatement();
			insertPlayerStmt.sqlConnection = con;
			
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
		
		
		/**
		 * 获取当前mv的信息
		 * @param mvid
		 */	
		public function getMVInfo(md:MusicData):void{
			currMd=md;
			var sql:String = "select * from mtv where No ="+currMd.mvid;
			MVStmt.text = sql;//准备待执行的sql语句
			MVStmt.addEventListener(SQLEvent.RESULT, getMVResult);
			MVStmt.addEventListener(SQLErrorEvent.ERROR, getMVError);  
			MVStmt.execute();//执行sql语句
		}
		protected function getMVResult(event:SQLEvent):void{
			MVStmt.removeEventListener(SQLEvent.RESULT, getMVResult);
			MVStmt.removeEventListener(SQLErrorEvent.ERROR, getMVError); 
			var result:SQLResult = MVStmt.getResult();
			if ( result.data != null ) 
			{  
				var row:Object = result.data[0]; 
				//         
				currMd.ismv=true;
				currMd.mvid=row.No;
				currMd.mName=row.name;
				currMd.playerName=row.singer;
				
				infodata.setRowMusicData(currMd);
				
			}else{
				infodata.musicNotFind();
			}
		}
		protected function getMVError(event:SQLErrorEvent):void
		{
			trace("提取mv失败！");
			MVStmt.removeEventListener(SQLEvent.RESULT, getMVResult);
			MVStmt.removeEventListener(SQLErrorEvent.ERROR, getMVError);
			infodata.musicNotFind();
		}
		
		
		//
		/**
		 * 搜索鱼丸榜 是否有此人（点歌的人） 
		 * @param nameid
		 */		
		public function selectYWId(nameid:int):void{
			var sql:String = "select * from people where nameid ="+nameid+";";
			SelectStmt.text = sql;//准备待执行的sql语句
			SelectStmt.addEventListener(SQLEvent.RESULT, selectMTVResult);
			SelectStmt.addEventListener(SQLErrorEvent.ERROR, selectMTVErrorHandle);  
			SelectStmt.execute();//执行sql语句
		} 
		protected function selectMTVResult(event:SQLEvent):void
		{
			
			SelectStmt.removeEventListener(SQLEvent.RESULT, selectMTVResult);
			SelectStmt.removeEventListener(SQLErrorEvent.ERROR, selectMTVErrorHandle);
			var result:SQLResult = SelectStmt.getResult();
			if ( result.data != null ) 
			{  
				var row:Object = result.data[0]; 
				
				infodata.newMusicData.selectPlayer.currYW=row.currYW;
				infodata.newMusicData.selectPlayer.nick=row.name;
				infodata.newMusicData.selectPlayer.notice=row.messages;
				infodata.newMusicData.selectPlayer.THMessage=row.leaveWord;
			 }	
			//
			infodata.addNewMusicData();
			
		}
		
		protected function selectMTVErrorHandle(event:SQLErrorEvent):void
		{
			SelectStmt.removeEventListener(SQLEvent.RESULT, selectMTVResult);
			SelectStmt.removeEventListener(SQLErrorEvent.ERROR, selectMTVErrorHandle);
			//
			infodata.addNewMusicData();
		}
		
		
		
		/**
		 * 收到鱼丸 添加
		 * @param p
		 */
		private var changeYW:PlayerData;
		public function addYW(p:PlayerData):void{
			changeYW=p;
			var sql:String = "select * from people where nameid ="+changeYW.id+";";
			SelectYW.text = sql;//准备待执行的sql语句
			SelectYW.addEventListener(SQLEvent.RESULT, selectYWResult);
			SelectYW.addEventListener(SQLErrorEvent.ERROR, selectYWErrorHandle);  
			SelectYW.execute();//执行sql语句
		}
		
		protected function selectYWResult(event:SQLEvent):void
		{
			SelectYW.removeEventListener(SQLEvent.RESULT, selectYWResult);
			SelectYW.removeEventListener(SQLErrorEvent.ERROR, selectYWErrorHandle); 
			var result:SQLResult = SelectYW.getResult();
			if ( result.data != null ) 
			{  
				var row:Object = result.data[0]; 
				changeYW.notice=row.notice;
				changeYW.totleYW=row.sumYW+changeYW.currYW;
				changeYW.currYW=row.currYW+changeYW.currYW;
				changePlayerData(changeYW);
			}	 			
		}
		
		protected function selectYWErrorHandle(event:SQLErrorEvent):void
		{
			SelectYW.removeEventListener(SQLEvent.RESULT, selectYWResult);
			SelectYW.removeEventListener(SQLErrorEvent.ERROR, selectYWErrorHandle);
			insertPlayer(changeYW); 			
		}		
		
		
		//新加入 player
		private function insertPlayer(people:PlayerData):void{
			var sql:String = "INSERT INTO people (nameid,name,messages,sumYW,currYW) VALUES ('"+people.id+"', '"+people.nick+"', '"+people.notice+"', '"+people.totleYW+"', '"+people.currYW+"')";
			insertPlayerStmt.text = sql;
			insertPlayerStmt.addEventListener(SQLEvent.RESULT, InsertSpResult);
			insertPlayerStmt.addEventListener(SQLErrorEvent.ERROR, InserSpError);  
			insertPlayerStmt.execute();//执行sql语句
		}
		
		protected function InsertSpResult(event:SQLEvent):void
		{
			insertPlayerStmt.removeEventListener(SQLEvent.RESULT, InsertSpResult);
			insertPlayerStmt.removeEventListener(SQLErrorEvent.ERROR, InserSpError);
			this.dispatchEvent(new Event(ADD_YW_COMPLETE)); 		
		}
		
		protected function InserSpError(event:SQLErrorEvent):void
		{
			insertPlayerStmt.removeEventListener(SQLEvent.RESULT, InsertSpResult);
			insertPlayerStmt.removeEventListener(SQLErrorEvent.ERROR, InserSpError);
			this.dispatchEvent(new Event(ADD_YW_COMPLETE)); 
		}
		
		
		/**
 		 * 修改数据库 player data: 1:鱼丸（总鱼丸，当前鱼丸） 2：土豪榜留言
		 * @param p:playerdata
		 */		
		public function changePlayerData(people:PlayerData):void{
			var sql:String="UPDATE people SET messages= "+people.notice+",sumYW= "+people.totleYW+",currYW="+people.currYW+" WHERE nameid = "+people.id+";"; 
			changePlayerStmt.text=sql;
			changePlayerStmt.addEventListener(SQLEvent.RESULT,changePlayerdataComplete);
			changePlayerStmt.addEventListener(SQLErrorEvent.ERROR,changePlayerdataError);
			changePlayerStmt.execute();
		}
		
		protected function changePlayerdataComplete(event:SQLEvent):void
		{
			changePlayerStmt.removeEventListener(SQLEvent.RESULT,changePlayerdataComplete);
			changePlayerStmt.removeEventListener(SQLErrorEvent.ERROR,changePlayerdataError);
			this.dispatchEvent(new Event(ADD_YW_COMPLETE));
		}
		
		protected function changePlayerdataError(event:SQLErrorEvent):void
		{
			changePlayerStmt.removeEventListener(SQLEvent.RESULT,changePlayerdataComplete);
			changePlayerStmt.removeEventListener(SQLErrorEvent.ERROR,changePlayerdataError);
			this.dispatchEvent(new Event(ADD_YW_COMPLETE));
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