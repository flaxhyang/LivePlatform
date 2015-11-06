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
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import douyu.vo.InfoData;
	import douyu.vo.MTVInfo;
	import douyu.vo.SelectMTVPeople;
	
	
	
	
	
	
	public class DataBase extends EventDispatcher
	{
		public static const LINK_DATABASE_COMPLETE:String="link_database_complete";
		
		public static const SELECTDB_FORMTV_COMPLETE:String="selectdb_formtv_complete";
		public static const SELECTDB_FORMTV_ERROR:String="selectdb_formtv_error";
		
		public static const SELECTDB_FORGIFT_COMPLETE:String="selectdb_forgift_complete";
		public static const SELECTDB_FORGIFT_ERROR:String="selectdb_forgift_error";
		
		public static const GET_MTV_COMPLETE:String="get_mtv_complete";
		public static const GET_MTV_ERROR:String="get_mtv_error";
//		public static const GET_PLAYMTV_COMPLETE:String="get_playMtv_complete";
		
		//送鱼丸 修改鱼丸流程完成
		public static const ADD_CURRYW_COMPLETE:String="add_curryw_complete";
		//修改送了鱼丸的点歌信息
		public static const UPDATA_SELECTINFO_COMPLETE:String="updata_selectinfo_complete";
		//点播后修改鱼丸
		public static const UPDATA_CURRYW_COMPLETE:String="updata_CurrYW_complete";
		
		
		//提取土豪榜完成
		public static const GET_TOPYW_COMPLETE:String="get_topyw_complete";
		public static const GET_TOPYW_ERROR:String="get_topyw_error";
		
		public static const INSER_NEW_SELECTPEOPLE_COMPLETE:String="Inser_new_SelectPeople_complete";
		
		public static const GET_SELECTMTV_TOP_COMPLETE:String="get_SelectMTV_Top_complete";
		
		public static const CONTINUITYSELECT_ERROR:String="ContinuitySelect_Error";
		public static const CONTINUITYSELECT_OK:String="ContinuitySelect_OK";
		
		public static const CONTINUITY_CHECK_OK:String="continuity_check_ok";
		public static const CONTINUITY_CHECK_ERROR:String="continuity_check_error";
		
		public static const LEAVEWORD_CHANGE_OK:String="leaveWord_change_ok";
		
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
			//判断有没有数据表contact，没有则建立之
//			stmt = new SQLStatement();//SQL声明类
//			stmt.sqlConnection = con;
			
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
		
		
		//------------------------------------------------------------mtv 
		
		public function selectCheckMVId(mvid:int):void{
			var sql:String = "select * from mtv where No ="+mvid;
			MVcheckStmt.text = sql;//准备待执行的sql语句
			MVcheckStmt.addEventListener(SQLEvent.RESULT, checkMVResult);
			MVcheckStmt.addEventListener(SQLErrorEvent.ERROR, checkMVError);  
			MVcheckStmt.execute();//执行sql语句
		}
		
		//提取 被点播前50的歌
//		public function getTopSelectMV():void{
//			selectTopMVStmt.text = "select * from mtv where type = 3 order by chooseNum desc limit 0,50"; 
//			selectTopMVStmt.addEventListener(SQLEvent.RESULT, selectTopMVResultHandler);
//			selectTopMVStmt.addEventListener(SQLErrorEvent.ERROR, selectTopMVErrorHandler);
//			selectTopMVStmt.execute(); 
//		}
		
//		protected function selectTopMVResultHandler(event:SQLEvent):void
//		{
//			var result:SQLResult = selectTopMVStmt.getResult();
//			if ( result.data != null ) 
//			{  
//				var numResults:int =result.data.length;//有多少条数据
//				var tempVector:Vector.<MTVInfo>=new Vector.<MTVInfo>();
//				for (var i:int = 0; i < numResults; i++)      
//				{          
//					var row:Object = result.data[i];
//					var currMvinfo:MTVInfo=new MTVInfo();
//					currMvinfo.No=row.No;
//					currMvinfo.name=row.name;
//					currMvinfo.type=row.type;
//					currMvinfo.chooseNum=row.chooseNum;
//					currMvinfo.image=row.image;
//					currMvinfo.url=row.url;
//					currMvinfo.id=row.id;
//					tempVector.push(currMvinfo);
//				}
//				infodata.selectTopMvVector= tempVector;
//			 }else{
//				trace("select data null!")	
//			}				
//			selectTopMVStmt.removeEventListener(SQLEvent.RESULT, selectTopMVResultHandler);
//			selectTopMVStmt.removeEventListener(SQLErrorEvent.ERROR, selectTopMVErrorHandler);
//		}		
//		protected function selectTopMVErrorHandler(event:SQLErrorEvent):void
//		{
//			selectTopMVStmt.removeEventListener(SQLEvent.RESULT, selectTopMVResultHandler);
//			selectTopMVStmt.removeEventListener(SQLErrorEvent.ERROR, selectTopMVErrorHandler);
//		}
		
		private var currAUTOMvNum:int=0;
		public function getAutoSelectMV():void{
			if(currAUTOMvNum>=infodata.autoPlayMvNums.length){
				currAUTOMvNum=0;
			}
			var playid:String=infodata.autoPlayMvNums[currAUTOMvNum];
			
			var sql:String = "select * from mtv where No ="+playid;
			selectTopMVStmt.text = sql; 
			selectTopMVStmt.addEventListener(SQLEvent.RESULT, selectTopMVResultHandler);
			selectTopMVStmt.addEventListener(SQLErrorEvent.ERROR, selectTopMVErrorHandler);
			selectTopMVStmt.execute();
			
			currAUTOMvNum++;
		}
		
		protected function selectTopMVResultHandler(event:SQLEvent):void
		{
			var result:SQLResult = selectTopMVStmt.getResult();
			if ( result.data != null ) 
			{
				var row:Object = result.data[0];
				var currMvinfo:MTVInfo=new MTVInfo();
				currMvinfo.No=row.No;
				currMvinfo.name=row.name;
//				currMvinfo.type=row.type;
//				currMvinfo.chooseNum=row.chooseNum;
//				currMvinfo.image=row.image;
				currMvinfo.url=row.url;
				currMvinfo.id=row.id;
				infodata.AutoPlayMvInfo=currMvinfo;
			}
		}
		
		protected function selectTopMVErrorHandler(event:SQLErrorEvent):void
		{
			
			
		}		
		
		
		//按类型提取mv
		public function selectMVinfos(type:int,num:int=30):void{
			var sql:String = "select * from mtv where type ="+type +" order by chooseNum desc limit 0,"+num;
			showMVStmt.text = sql;
			showMVStmt.addEventListener(SQLEvent.RESULT, getMVinfosResult);
			showMVStmt.addEventListener(SQLErrorEvent.ERROR, getMVinfosError);  
			showMVStmt.execute();
		}
		
		//按点播率提取mv
		public function selectMaxMv(num:int=30):void{
			var sql:String ="select * from mtv order by chooseNum desc limit 0,"+num; 
			showMVStmt.text = sql;
			showMVStmt.addEventListener(SQLEvent.RESULT, getMVinfosResult);
			showMVStmt.addEventListener(SQLErrorEvent.ERROR, getMVinfosError);  
			showMVStmt.execute();
		}
		
		//按新歌提取mv
		public function selectNewMVinfos(num:int=30):void{
			showMVStmt.text = "select * from mtv order by id desc limit 0,"+num; 
			showMVStmt.addEventListener(SQLEvent.RESULT, getMVinfosResult);
			showMVStmt.addEventListener(SQLErrorEvent.ERROR, getMVinfosError);  
			showMVStmt.execute();
		}
		
		protected function getMVinfosError(event:SQLErrorEvent):void
		{
			trace("分类提取mtv失败！");
			showMVStmt.removeEventListener(SQLEvent.RESULT, getMVinfosResult);
			showMVStmt.removeEventListener(SQLErrorEvent.ERROR, getMVinfosError);
		}
		
		/**
		 * 获取当前mv的信息
		 * @param mvid
		 */		
		public function getMVInfo(mvid:int):void{
			var sql:String = "select * from mtv where No ="+mvid;
			MVStmt.text = sql;//准备待执行的sql语句
			MVStmt.addEventListener(SQLEvent.RESULT, getMVResult);
			MVStmt.addEventListener(SQLErrorEvent.ERROR, getMVError);  
			MVStmt.execute();//执行sql语句
		}
		
		protected function getMVError(event:SQLErrorEvent):void
		{
			trace("提取mv失败！");
			MVStmt.removeEventListener(SQLEvent.RESULT, getMVResult);
			MVStmt.removeEventListener(SQLErrorEvent.ERROR, getMVError);
		}
		
		/**
		 * 修改点播mv的次数
		 * @param mvid
		 */		
		public function updataMvInfo(mvid:int):void{
			var sql:String = "UPDATE mtv SET chooseNum= chooseNum +1 WHERE No = "+mvid+";";
			MVStmt.text = sql;//准备待执行的sql语句
			MVStmt.addEventListener(SQLEvent.RESULT, updataMVResult);
			MVStmt.addEventListener(SQLErrorEvent.ERROR, updataMVError);  
			MVStmt.execute();//执行sql语句
			//
			changeMysql(mvid);
		}
		
		protected function updataMVResult(event:SQLEvent):void
		{
			trace("点歌成功后，修改当前歌曲点播次数");
			MVStmt.removeEventListener(SQLEvent.RESULT, updataMVResult);
			MVStmt.removeEventListener(SQLErrorEvent.ERROR, updataMVError); 
			
		}
		protected function updataMVError(event:SQLErrorEvent):void
		{
			trace("点歌成功后，修改当前歌曲点播次数 失败！");
			MVStmt.removeEventListener(SQLEvent.RESULT, updataMVResult);
			MVStmt.removeEventListener(SQLErrorEvent.ERROR, updataMVError); 
		}
		
		public function changeMysql(mvNo:int):void
		{
	        var checkurl:String="http://maoxiaopang.com/MTV/MTV/MVchooseNum.php";
			var urlloader:URLLoader=new URLLoader();
			urlloader.addEventListener(Event.COMPLETE,function InsertCompleteHandles(evt:Event):void{
				
				var jsonObject:Object = JSON.parse(urlloader.data);
				if(int(jsonObject.error))
				{
					trace("error");				
				}else{
					trace("ok");
				}
			});
			var param:URLVariables=new URLVariables();
			param["mvNo"]=mvNo;
			var req:URLRequest = new URLRequest(checkurl);
			req.method = "POST";
			req.data=param;
			urlloader.load(req);
		}
		
		//----------------------------------------------------------people
		//修改留言
		public function leaveWord(id:String,msg:String):void{
			leaveWordStmt.text = "UPDATE people SET leaveWord = '"+msg+"' WHERE nameid = "+id+";"; 
			leaveWordStmt.addEventListener(SQLEvent.RESULT, leaveWordHandler);
			leaveWordStmt.addEventListener(SQLErrorEvent.ERROR, leaveWordErrorHandler);
			leaveWordStmt.execute();
		}
		
		protected function leaveWordHandler(event:SQLEvent):void
		{
			trace("leaveWord ok");
			this.dispatchEvent(new Event(LEAVEWORD_CHANGE_OK));
		}
		
		protected function leaveWordErrorHandler(event:SQLErrorEvent):void
		{
			trace("leaveWord error");
			this.dispatchEvent(new Event(LEAVEWORD_CHANGE_OK));
		}
		
		//搜索鱼丸榜 是否有此人（点歌的人）
		public function selectYWId(nameid:int):void{
			var sql:String = "select * from people where nameid ="+nameid+";";
			SelectStmt.text = sql;//准备待执行的sql语句
			SelectStmt.addEventListener(SQLEvent.RESULT, selectMTVResult);
			SelectStmt.addEventListener(SQLErrorEvent.ERROR, selectMTVErrorHandle);  
			SelectStmt.execute();//执行sql语句
		} 
		
		//鱼丸榜里 是否由此人（本次鱼丸数必须够1000）
		public function checkContinuityPeopleId(id:int):void{
			var sql:String = "select * from people where nameid ="+id;
			checkContinuityStmt.text = sql;//准备待执行的sql语句
			checkContinuityStmt.addEventListener(SQLEvent.RESULT, checkContinuityResult);
			checkContinuityStmt.addEventListener(SQLErrorEvent.ERROR, checkContinuityErrorHandle);  
			checkContinuityStmt.execute();//执行sql语句
		}
		
		//select gift fish
		public function selectgiftId(nameid:int):void{
			var sql:String = "select * from people where nameid ="+nameid;
			giftYWStmt.text = sql;//准备待执行的sql语句
			giftYWStmt.addEventListener(SQLEvent.RESULT, selectgiftResult);
			giftYWStmt.addEventListener(SQLErrorEvent.ERROR, selectError);  
			giftYWStmt.execute();//执行sql语句
		} 
		
		protected function selectgiftResult(event:SQLEvent):void{
			giftYWStmt.removeEventListener(SQLEvent.RESULT, selectgiftResult);
			giftYWStmt.removeEventListener(SQLErrorEvent.ERROR, selectError);
			var result:SQLResult = giftYWStmt.getResult();
			if ( result.data != null ) 
			{  
				this.dispatchEvent(new Event(SELECTDB_FORGIFT_COMPLETE));
			 }else{
				this.dispatchEvent(new Event(SELECTDB_FORGIFT_ERROR));
			}				
		}
		
		
		//添加 送鱼丸的人
//		public function insert(nameid:int,name:String):void{
//			var sql:String = "INSERT INTO people (nameid, name) VALUES ('"+nameid+"', '"+name+"')";
//			stmt.text = sql;//准备待执行的sql语句
//			stmt.addEventListener(SQLEvent.RESULT, InsertResult);
//			stmt.addEventListener(SQLErrorEvent.ERROR, InsertError);  
//			stmt.execute();//执行sql语句
//		}
		
		//添加 从点歌表里 先点歌 后送鱼丸的人
		public function insertSelectPeople(people:SelectMTVPeople):void{
//			var sql:String = "INSERT INTO people (nameid,name,chooseMTV,messages) VALUES ('"+people.id+"', '"+people.name+"', '"+people.MTVids+"', '"+people.message+"')";
			var sql:String = "INSERT INTO people (nameid,name,chooseMTV,messages,sumYW,currYW) VALUES ('"+people.id+"', '"+people.name+"', '"+people.MTVids+"', '"+people.message+"', '"+people.currYw+"', '"+people.currYw+"')";
			giftYWStmt.text = sql;//准备待执行的sql语句
			giftYWStmt.addEventListener(SQLEvent.RESULT, InsertSpResult);
			giftYWStmt.addEventListener(SQLErrorEvent.ERROR, InserSptError);  
			giftYWStmt.execute();//执行sql语句
		}
		
		/**
		 * 修改鱼丸数（sumYW +1，currYW+1：没有点歌信息）
		 * @param nameid
		 */		
		public function updataYW(people:SelectMTVPeople):void{
			giftYWStmt.text = "UPDATE people SET sumYW= sumYW +"+people.currYw+",currYW=currYW+"+people.currYw+" WHERE nameid = "+people.id+";"; 
			giftYWStmt.addEventListener(SQLEvent.RESULT, addYWResultHandler);
			giftYWStmt.addEventListener(SQLErrorEvent.ERROR, addYWErrorHandler);
			giftYWStmt.execute(); 
		}
		
		/**
		 * 修改鱼丸数（sumYW +1，currYW+1，& 修改点歌信息）
		 * @param nameid
		 */		
		public function updataYWAndSelectMTV(people:SelectMTVPeople):void{
			
			giftYWStmt.text = "UPDATE people SET sumYW= sumYW +"+people.currYw+",currYW=currYW+"+people.currYw+",chooseMTV='"+people.MTVids+"',messages='"+people.message+"' WHERE nameid = "+people.id; 
			giftYWStmt.addEventListener(SQLEvent.RESULT, addYWResultHandler);
			giftYWStmt.addEventListener(SQLErrorEvent.ERROR, addYWErrorHandler);
			giftYWStmt.execute(); 
		}
		
		public function updataContinuitySelectMTV(people:SelectMTVPeople):void{
			giftYWStmt.text = "UPDATE people SET chooseMTV='"+people.MTVids+"',messages='"+people.message+"' WHERE nameid = "+people.id; 
			giftYWStmt.addEventListener(SQLEvent.RESULT, ContinuitySelectHandler);
			giftYWStmt.addEventListener(SQLErrorEvent.ERROR, ContinuitySelectErrorHandler);
			giftYWStmt.execute(); 
		}
		
		
		protected function ContinuitySelectErrorHandler(event:SQLErrorEvent):void
		{
			giftYWStmt.removeEventListener(SQLEvent.RESULT, ContinuitySelectHandler);
			giftYWStmt.removeEventListener(SQLErrorEvent.ERROR, ContinuitySelectErrorHandler);
			this.dispatchEvent(new Event(CONTINUITYSELECT_ERROR));
		}
		
		protected function ContinuitySelectHandler(event:SQLEvent):void
		{
			giftYWStmt.removeEventListener(SQLEvent.RESULT, ContinuitySelectHandler);
			giftYWStmt.removeEventListener(SQLErrorEvent.ERROR, ContinuitySelectErrorHandler);
			this.dispatchEvent(new Event(CONTINUITYSELECT_OK));
		}		
		
		protected function addYWErrorHandler(event:SQLErrorEvent):void
		{
			giftYWStmt.removeEventListener(SQLEvent.RESULT, addYWResultHandler);
			giftYWStmt.removeEventListener(SQLErrorEvent.ERROR, addYWErrorHandler);
			this.dispatchEvent(new Event(ADD_CURRYW_COMPLETE));
		}
		
		protected function addYWResultHandler(event:SQLEvent):void
		{
			giftYWStmt.removeEventListener(SQLEvent.RESULT, addYWResultHandler);
			giftYWStmt.removeEventListener(SQLErrorEvent.ERROR, addYWErrorHandler);
			this.dispatchEvent(new Event(ADD_CURRYW_COMPLETE));
		}
		
		/**
		 * 修改已经送鱼丸人的点歌信息
		 * @param people
		 */		
		public function updataMTV(people:SelectMTVPeople):void{
//			SelectStmt.text = "UPDATE people SET chooseMTV="+people.MTVid+",messages="+people.message+" WHERE nameid = "+people.id; 
			SelectStmt.text = "UPDATE people SET chooseMTV='"+people.MTVids+"',messages='"+people.message+"' WHERE nameid = "+people.id; 
			SelectStmt.addEventListener(SQLEvent.RESULT, uodateResultHandler);
			SelectStmt.addEventListener(SQLErrorEvent.ERROR, uodateErrorHandler);
			SelectStmt.execute(); 
		}
		
		
		
		//获取鱼丸前几名的人
		public function getTopYWPeople():void{
//			stmt.text = "SELECT top2 * FROM people ORDER BY sumYW asc";
			topallStmt.text = "select * from people order by sumYW desc limit 0,10"; 
			topallStmt.addEventListener(SQLEvent.RESULT, selectResultHandler);
			topallStmt.addEventListener(SQLErrorEvent.ERROR, selectErrorHandler);
			topallStmt.execute(); 
		}
		
		//点歌排序
		//点播下一首时刷新排行列表
		public function getTopMTVSForPlay():void{
			playmvStmt.text = "select * from people where currYW > 0 and chooseMTV > 0 order by currYW desc limit 0,10"; 
			playmvStmt.addEventListener(SQLEvent.RESULT, getTopMTVSForPlayHandler);
			playmvStmt.addEventListener(SQLErrorEvent.ERROR, getTopMTVSForPlayErrorHandler);
			playmvStmt.execute();
		}
		
		//按时间  刷新点播列表
		public function getTopMTVSForTopList(num:int):void{
			if(getTopmvStmt.executing)return;
			getTopmvStmt.text = "select * from people where currYW > 0 and chooseMTV !='' order by currYW desc limit 0,"+num; 
			getTopmvStmt.addEventListener(SQLEvent.RESULT, getTopMTVSHandler);
			getTopmvStmt.addEventListener(SQLErrorEvent.ERROR, getTopMTVSErrorHandler);
			getTopmvStmt.execute();
		} 
		
		/**
		 * 点歌完成后修改 点歌人的信息:每次减掉200鱼丸。
		 * @param peopleId
		 */		
//		public function updataSelectPeopleCurrYW(peopleId:int):void{
//			updataPStmt.text = "UPDATE people SET currYW=0,chooseMTV='',messages='',chooseNum=chooseNum+1 WHERE nameid = "+peopleId+";";
//			updataPStmt.addEventListener(SQLEvent.RESULT, playMTVCompleteResultHandler);
//			updataPStmt.addEventListener(SQLErrorEvent.ERROR, playMTVErrorHandler);
//			updataPStmt.execute();
//		}
		public function updataSelectPeopleCurrYW(peopleId:int):void{
			updataPStmt.text = "select * from people WHERE nameid = "+peopleId+";";
			updataPStmt.addEventListener(SQLEvent.RESULT,function getpeopleResultHandler(evt:SQLEvent):void{
				updataPStmt.removeEventListener(SQLEvent.RESULT, getpeopleResultHandler);
				updataPStmt.removeEventListener(SQLErrorEvent.ERROR, getpeopleErrorHandler);
				var result:SQLResult = updataPStmt.getResult();
				if ( result.data != null ) 
				{  
					var row:Object = result.data[0];          
					var currYWNum:int=int(row.currYW)-2;
					currYWNum=currYWNum<0?0:currYWNum;
					changeSelectPeopleCurrYW(peopleId,currYWNum);
				}
			});
			updataPStmt.addEventListener(SQLErrorEvent.ERROR, getpeopleErrorHandler);
			updataPStmt.execute();
		}
		
		public function changeSelectPeopleCurrYW(peopleId:int,ywNum:int):void{
			updataPStmt.text = "UPDATE people SET currYW="+ ywNum +",chooseMTV='',messages='',chooseNum=chooseNum+1 WHERE nameid = "+peopleId+";";
			updataPStmt.addEventListener(SQLEvent.RESULT, playMTVCompleteResultHandler);
			updataPStmt.addEventListener(SQLErrorEvent.ERROR, playMTVErrorHandler);
			updataPStmt.execute();
		}
		
		protected function getpeopleErrorHandler(event:SQLErrorEvent):void
		{
			
		}
		/**
		 * 不扣鱼丸的点歌人的操作
		 * @param peopleId
		 */		
		public function updataSelectPeopleCurrYWTemp(peopleId:int):void{
			updataPStmt.text = "UPDATE people SET chooseMTV='',messages='' WHERE nameid = "+peopleId+";";
			updataPStmt.addEventListener(SQLEvent.RESULT, playMTVCompleteResultHandler);
			updataPStmt.addEventListener(SQLErrorEvent.ERROR, playMTVErrorHandler);
			updataPStmt.execute();
		}
		//-------------------------------------------------------------------
		// result
		//-------------------------------------------------------------------
		
		protected function getMVResult(event:SQLEvent):void{
			MVStmt.removeEventListener(SQLEvent.RESULT, getMVResult);
			MVStmt.removeEventListener(SQLErrorEvent.ERROR, getMVError); 
			var result:SQLResult = MVStmt.getResult();
			if ( result.data != null ) 
			{  
				var row:Object = result.data[0];          
				var currGetMTV:MTVInfo=new MTVInfo();
				currGetMTV.No=row.No;
				currGetMTV.name=row.name;
				currGetMTV.type=row.type;
				currGetMTV.chooseNum=row.chooseNum;
				currGetMTV.image=row.image;
				currGetMTV.url=	row.url;
				InfoData.instant.currGetMTV=currGetMTV;
			}
		}
		
		protected function checkMVResult(event:SQLEvent):void{
			MVcheckStmt.removeEventListener(SQLEvent.RESULT, checkMVResult);
			MVcheckStmt.removeEventListener(SQLErrorEvent.ERROR, checkMVError);  
			var result:SQLResult = MVcheckStmt.getResult();
			if ( result.data != null ) 
			{  
				this.dispatchEvent(new Event(GET_MTV_COMPLETE));
			 }else{
				this.dispatchEvent(new Event(GET_MTV_ERROR));
			}				
		}
		
		protected function checkMVError(event:SQLErrorEvent):void
		{
			trace("检查音乐库里是否有此歌曲——失败！");
			MVcheckStmt.removeEventListener(SQLEvent.RESULT, checkMVResult);
			MVcheckStmt.removeEventListener(SQLErrorEvent.ERROR, checkMVError); 
		}
		
		
		protected function checkContinuityResult(event:SQLEvent):void{
			checkContinuityStmt.removeEventListener(SQLEvent.RESULT, checkContinuityResult);
			checkContinuityStmt.removeEventListener(SQLErrorEvent.ERROR, checkContinuityErrorHandle); 
			var result:SQLResult = checkContinuityStmt.getResult();
			if ( result.data != null ) 
			{  
				var row:Object = result.data[0]; 
				if(row.currYW>=MinContinuityLimit){
					currContnuityNum=Math.floor(row.currYW/ContinuityStepNum);
					this.dispatchEvent(new Event(CONTINUITY_CHECK_OK));
				}else{
					this.dispatchEvent(new Event(CONTINUITY_CHECK_ERROR));
				}      
			 }else{
				this.dispatchEvent(new Event(CONTINUITY_CHECK_ERROR));
			}					
		}
		
		protected function checkContinuityErrorHandle(event:SQLEvent):void{
			checkContinuityStmt.removeEventListener(SQLEvent.RESULT, checkContinuityResult);
			checkContinuityStmt.removeEventListener(SQLErrorEvent.ERROR, checkContinuityErrorHandle);  
			this.dispatchEvent(new Event(CONTINUITY_CHECK_ERROR));
		}
		
		protected function selectMTVResult(event:SQLEvent):void
		{
			
			SelectStmt.removeEventListener(SQLEvent.RESULT, selectMTVResult);
			SelectStmt.removeEventListener(SQLErrorEvent.ERROR, selectMTVErrorHandle);
			var result:SQLResult = SelectStmt.getResult();
			if ( result.data != null ) 
			{  
				var row:Object = result.data[0]; 
				if(row.currYW>0){
					this.dispatchEvent(new Event(SELECTDB_FORMTV_COMPLETE));
				}else{
					this.dispatchEvent(new Event(SELECTDB_FORMTV_ERROR));
				}      
			 }else{
				this.dispatchEvent(new Event(SELECTDB_FORMTV_ERROR));
			}				
			
		}
		
		
		
		
		protected function getTopMTVSForPlayHandler(event:SQLEvent):void{
			playmvStmt.removeEventListener(SQLEvent.RESULT, getTopMTVSForPlayHandler);
			playmvStmt.removeEventListener(SQLErrorEvent.ERROR, getTopMTVSForPlayErrorHandler);
			var result:SQLResult = playmvStmt.getResult();
			if( result.data != null ){
				var tempSMTVPeople:Vector.<SelectMTVPeople>=new Vector.<SelectMTVPeople>();
				var numResults:int =result.data.length;//有多少条数据
				for (var i:int = 0; i < numResults; i++)      
				{          
					var row:Object = result.data[i];          
					var smp:SelectMTVPeople=new SelectMTVPeople();
					smp.id=row.nameid;
					smp.name=row.name;
					smp.MTVids=row.chooseMTV;
					smp.currYw=row.currYW;
					smp.message=row.messages;	          
					tempSMTVPeople.push(smp);      
				} 
				setPlayList(tempSMTVPeople);
			}else{
				setPlayList();
			}
		}
		
		protected function getTopMTVSForPlayErrorHandler(event:SQLEvent):void{
			playmvStmt.removeEventListener(SQLEvent.RESULT, getTopMTVSForPlayHandler);
			playmvStmt.removeEventListener(SQLErrorEvent.ERROR, getTopMTVSForPlayErrorHandler);
		}
		
		private function setPlayList(list:Vector.<SelectMTVPeople>=null):void{
			if(list){
				var sy:int=10-list.length;
				if(sy){
//					trace(list[0]);
					var curr:Vector.<SelectMTVPeople>=infodata.getSelectMTVPeopleTop(sy);
					list=list.concat(curr);
					//list.concat(infodata.getSelectMTVPeopleTop(sy));
				}
			}else{
				list=infodata.getSelectMTVPeopleTop(10);
			}
			infodata.TopSelectPeoples=list;
			
		}
		
		protected function getTopMTVSHandler(event:SQLEvent):void{
			getTopmvStmt.removeEventListener(SQLEvent.RESULT, getTopMTVSForPlayHandler);
			getTopmvStmt.removeEventListener(SQLErrorEvent.ERROR, getTopMTVSForPlayErrorHandler);
			var result:SQLResult = getTopmvStmt.getResult();
			if( result.data != null ){
				var tempSMTVPeople:Vector.<SelectMTVPeople>=new Vector.<SelectMTVPeople>();
				var numResults:int =result.data.length;//有多少条数据
				for (var i:int = 0; i < numResults; i++)      
				{          
					var row:Object = result.data[i];          
					var smp:SelectMTVPeople=new SelectMTVPeople();
					smp.id=row.nameid;
					smp.name=row.name;
					smp.MTVids=row.chooseMTV;
					smp.currYw=row.currYW;
					smp.message=row.messages;	          
					tempSMTVPeople.push(smp);      
				} 
				setPlayList(tempSMTVPeople);
			}else{
				setPlayList();
			}
			
			this.dispatchEvent(new Event(GET_SELECTMTV_TOP_COMPLETE));
		}
		
		//轮询 歌曲 显示 用的
		protected function getMVinfosResult(event:SQLEvent):void
		{
			showMVStmt.removeEventListener(SQLEvent.RESULT, getMVinfosResult);
			showMVStmt.removeEventListener(SQLErrorEvent.ERROR, getMVinfosError); 
			var result:SQLResult = showMVStmt.getResult();
			var currVes:Vector.<MTVInfo>=new Vector.<MTVInfo>();
			if ( result.data != null ) 
			{  
				var numResults:int =result.data.length;//有多少条数据
				for (var i:int = 0; i < numResults; i++)      
				{          
					var row:Object = result.data[i];          
					var mi:MTVInfo=new MTVInfo();         
					mi.image=row.image;
					mi.name=row.name;
					mi.No=row.No;
					currVes.push(mi);   
				}  
				infodata.showMVinfoVes=currVes;
			 }else{
				trace("select data null!")	
			}				
		}
		//土豪榜
		private var tempTopYWVec:Vector.<SelectMTVPeople>
		protected function selectResultHandler(event:SQLEvent):void
		{
			topallStmt.removeEventListener(SQLEvent.RESULT, selectResultHandler);
			topallStmt.removeEventListener(SQLErrorEvent.ERROR, selectErrorHandler);
			var result:SQLResult = topallStmt.getResult();
			if ( result.data != null ) 
			{  
				var numResults:int =result.data.length;//有多少条数据
				tempTopYWVec=new Vector.<SelectMTVPeople>();
				for (var i:int = 0; i < numResults; i++)      
				{          
					var row:Object = result.data[i];          
//					trace("sumYW="+row.sumYW);
					var currsmp:SelectMTVPeople=new SelectMTVPeople();
					currsmp.id=row.nameid;
					currsmp.name=row.name;
					currsmp.sumYW=row.sumYW;
					currsmp.leaveWord=row.leaveWord;	          
					tempTopYWVec.push(currsmp);     
				}  
				
				infodata.topYWVector=tempTopYWVec;
				
				this.dispatchEvent(new Event(GET_TOPYW_COMPLETE));
			 }else{
//				trace("select data null!")
				this.dispatchEvent(new Event(CONTINUITY_CHECK_ERROR));
			}				
		}
		
		
		protected function playMTVErrorHandler(event:SQLErrorEvent):void
		{
			trace("点歌成功后，修改当前鱼丸数 失败！");
			updataPStmt.removeEventListener(SQLEvent.RESULT, playMTVCompleteResultHandler);
			updataPStmt.removeEventListener(SQLErrorEvent.ERROR, playMTVErrorHandler);
		}
		
		protected function playMTVCompleteResultHandler(event:SQLEvent):void
		{
			updataPStmt.removeEventListener(SQLEvent.RESULT, playMTVCompleteResultHandler);
			updataPStmt.removeEventListener(SQLErrorEvent.ERROR, playMTVErrorHandler);
			trace("点歌成功后，修改当前鱼丸数");
			this.dispatchEvent(new Event(UPDATA_CURRYW_COMPLETE));
		}
		
		
		
		
		protected function uodateResultHandler(event:SQLEvent):void
		{
			SelectStmt.removeEventListener(SQLEvent.RESULT, uodateResultHandler);
			SelectStmt.removeEventListener(SQLErrorEvent.ERROR, uodateErrorHandler);
			this.dispatchEvent(new Event(UPDATA_SELECTINFO_COMPLETE));
		}
		
		protected function uodateErrorHandler(event:SQLErrorEvent):void
		{
			SelectStmt.removeEventListener(SQLErrorEvent.ERROR, uodateErrorHandler);
			SelectStmt.removeEventListener(SQLEvent.RESULT, uodateResultHandler);
			this.dispatchEvent(new Event(UPDATA_SELECTINFO_COMPLETE));
		}
		
		protected function InsertSpResult(event:SQLEvent):void
		{
			giftYWStmt.removeEventListener(SQLEvent.RESULT, InsertSpResult);
			giftYWStmt.removeEventListener(SQLErrorEvent.ERROR, InserSptError);
			this.dispatchEvent(new Event(INSER_NEW_SELECTPEOPLE_COMPLETE));
			trace("INSERT ok")
		}
		
		protected function selectMTVErrorHandle(event:SQLErrorEvent):void
		{
			SelectStmt.removeEventListener(SQLEvent.RESULT, selectMTVResult);
			SelectStmt.removeEventListener(SQLErrorEvent.ERROR, selectMTVErrorHandle);
			this.dispatchEvent(new Event(SELECTDB_FORMTV_ERROR));
			trace("select----MTV---Error 3115")
		}
		
		protected function selectError(event:SQLErrorEvent):void
		{
			giftYWStmt.removeEventListener(SQLEvent.RESULT, selectgiftResult);
			giftYWStmt.removeEventListener(SQLErrorEvent.ERROR, selectError);
			this.dispatchEvent(new Event(SELECTDB_FORGIFT_ERROR));
			trace("select id Error")
		}
		protected function getTopMTVSErrorHandler(event:SQLErrorEvent):void
		{
			getTopmvStmt.removeEventListener(SQLEvent.RESULT, getTopMTVSHandler);
			getTopmvStmt.removeEventListener(SQLErrorEvent.ERROR, getTopMTVSErrorHandler);
			this.dispatchEvent(new Event(GET_SELECTMTV_TOP_COMPLETE));
			trace("selectMTVTOPError")
		}		
		
		
		protected function InserSptError(event:SQLErrorEvent):void
		{
			giftYWStmt.removeEventListener(SQLEvent.RESULT, InsertSpResult);
			giftYWStmt.removeEventListener(SQLErrorEvent.ERROR, InserSptError);
			this.dispatchEvent(new Event(INSER_NEW_SELECTPEOPLE_COMPLETE));
			trace("InsertError");
		}
		
		protected function selectErrorHandler(event:SQLErrorEvent):void
		{
			topallStmt.removeEventListener(SQLEvent.RESULT, selectResultHandler);
			topallStmt.removeEventListener(SQLErrorEvent.ERROR, selectErrorHandler);
//			trace("selectYWTOPError")
			this.dispatchEvent(new Event(CONTINUITY_CHECK_ERROR));
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