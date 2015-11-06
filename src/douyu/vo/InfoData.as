package douyu.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import douyu.database.DataBase;
	
	public class InfoData extends EventDispatcher
	{
		
		//private var socketlink:SocketLink=SocketLink.instant;
		
		//public static const HeitiSC:Font=new Heiti_SC();
		
		public static const DM_IS_LINK:String="dm_is_link";
		public static const GETMVINFOS_COMPLETE_EVENT:String="getMvInfos_complete_event";
		public static const TOP_SELECTMTV_COMPLETE:String="top_selectMTV_complete";
		public static const PLAY_MV_COMPLETE:String="play_mv_complete";
		
		//old 选择连续播放的mv完成 。     0417修改 ： 用来显示每首歌的编号 取歌信息完成
		public static const SELECT_TOP_MV:String="select_top_mv";
	
		
//		var file:File=new File("D:/Workspace/minGame/YZYDouyu/src/videos/YZYDOUYUData.db");
//		var file:File=new File("G:/FBWORK/YZYDouyu/src/videos/YZYDOUYUData.db");
//		public static const DataBaseURL:String="C:/YZYDOUYUData.db";
		
		public static const AUTOMSGURL:String="/videos/word.txt";
		public static const AUTOBlackMsgURL:String="/videos/blackword.txt";
		public static const MTVLISTURL:String="/videos/mtvlist.txt";
        
		//work
//		public static const MTVImage:String="i:/MTVImage/";
		//
		public static const DataBaseURL:String="D:/Workspace/minGame/YZYDouyu9.17/src/videos/YZYDOUYUData0317.db";
		public static const MTVURL:String="i:/mtv/";
		public static const MTVImage:String="D:/Workspace/minGame/YZYDouyu9.17/src/videos/image/";
		public static const AuthorityURL:String="D:/Workspace/minGame/YZYDouyu9.17/src/videos/Authority.txt";
		public static const noticeURL:String="D:/Workspace/minGame/YZYDouyu9.17/src/videos/Notice.txt";
		public static const mmURL:String="D:/Workspace/minGame/YZYDouyu9.17/src/videos/MM.txt";
		public static const mmImage:String="D:/Workspace/minGame/YZYDouyu9.17/src/videos/";
		
		//home
//		public static const DataBaseURL:String="G:/FBWORK/YZYDouyu9.25/src/videos/YZYDOUYUData0317.db";
//		public static const AuthorityURL:String="G:/FBWORK/YZYDouyu9.25/src/videos/Authority.txt";
//		public static const noticeURL:String="G:/FBWORK/YZYDouyu9.25/src/videos/Notice.txt";
//		public static const mmURL:String="G:/FBWORK/YZYDouyu9.25/src/videos/MM.txt";
//		public static const mmImage:String="G:/FBWORK/YZYDouyu9.25/src/videos/";
//		public static const MTVURL:String="i:/mtv/";
//		public static const MTVImage:String="i:/MTVImage/";
		
//		public static const MTVURL:String="K:/mtv/";
//		public static const MTVImage:String="k:/MTVImage/";
		
		
		//发布
//		public static const DataBaseURL:String="C:/YZYDOUYUData.db";
//		public static const MTVURL:String="d:/mtv/";
//		public static const MTVImage:String="d:/MTVImage/";
//		public static const AuthorityURL:String="C:/Authority.txt";
//		public static const noticeURL:String="C:/Notice.txt";
//		public static const mmURL:String="C:/MM.txt";
//		public static const mmImage:String="d:/mmimage/";
		
		
		public static const TopListWidth:int=170;
		
		private var db:DataBase;
		
		private  var _isLink:Boolean=false;

		public  function get isLink():Boolean
		{
			return _isLink;
		}

		public  function set isLink(value:Boolean):void
		{
			_isLink = value;
			if(value){
				this.dispatchEvent(new Event(DM_IS_LINK));
			}
		}

		private var socketlink:Link=Link.instant;
		
		public function InfoData(target:IEventDispatcher=null)
		{
			super(target);
		}
		//----------------------------------------------------------------------
		//
		public function getAUTOMvlist():void{
			var mtvlistloader:URLLoader=new URLLoader();
			var Request:URLRequest=new URLRequest(InfoData.MTVLISTURL);
			mtvlistloader.addEventListener(Event.COMPLETE,function blackwordhandle():void{
				autoPlayMvNums=String(mtvlistloader.data).split(",");
			});
			mtvlistloader.load(Request);
		}
		
		
		
		//----------------------------------------------------------------------
		//切歌功能
		private var _GMIDVec:Vector.<int>=new Vector.<int>()

		public function get GMIDVec():Vector.<int>
		{
			return _GMIDVec;
		}

		public function set GMIDVec(value:Vector.<int>):void
		{
			_GMIDVec = value;
		}

		public function isGM(id:int):Boolean{
			for each (var i:int in GMIDVec) 
			{
				if(id==i){
					return true;
				}
			}
			return false;
		}
		
		//----------------------------------------------------------------------
		//没送鱼丸的点歌排行
		private const sMTVPMax:int=200;
		public var _selectMTVPeoples:Vector.<SelectMTVPeople>=new Vector.<SelectMTVPeople>();
		//----------------------------------------------------------------------
		// 单独点歌的流程
		//-----------------------------------------------------------------------
		private var selectQueyeIsRun:Boolean=false;
		private var nextSPItem:SelectMTVPeople;
		private var _selectQueueArr:Vector.<SelectMTVPeople>=new Vector.<SelectMTVPeople>();
		public function setSelectQueueArr(value:SelectMTVPeople):void
		{
			_selectQueueArr.push(value);
			if(!selectQueyeIsRun){
				selectQueyeIsRun=true;
				selectRun();
			}
		}
		private function selectRun():void{
			if(!db){
				db=DataBase.instant;
			}
			nextSPItem=_selectQueueArr.shift();
			if(nextSPItem!=null){
				//点歌时判断是否有此歌曲
				db.addEventListener(DataBase.GET_MTV_COMPLETE,selectIfMTVDBcompleteHandle);
				db.addEventListener(DataBase.GET_MTV_ERROR,selectIfMTVDBorrorHandle);
				db.selectCheckMVId(nextSPItem.MTVisVec[0]);
			}else{
				selectQueyeIsRun=false;
			}
		}
		
		protected function selectIfMTVDBorrorHandle(event:Event):void
		{
			db.removeEventListener(DataBase.GET_MTV_COMPLETE,selectIfMTVDBcompleteHandle);
			db.removeEventListener(DataBase.GET_MTV_ERROR,selectIfMTVDBorrorHandle);
			socketlink.sendMsg("没有编号为："+nextSPItem.MTVisVec[0]+"的歌曲![emot:grief]");
			selectRun();
		}
		
		private var currTankNum:uint=0;
		protected function selectIfMTVDBcompleteHandle(event:Event):void
		{
			db.removeEventListener(DataBase.GET_MTV_COMPLETE,selectIfMTVDBcompleteHandle);
			db.removeEventListener(DataBase.GET_MTV_ERROR,selectIfMTVDBorrorHandle);
			//
			if(currTankNum>1){
				currTankNum=0;
			}
			if(currTankNum){
				socketlink.sendMsg("点播成功！请等待点歌榜的刷新信息![emot:grief]");
			}else{
				socketlink.sendMsg("点播成功！请等待点歌榜的刷新信息![emot:grief][emot:grief]");
			}
			currTankNum++;
			//
		    //TextBoard.instant.setZhufu(nextSPItem.name+"成功点播：编号"+nextSPItem.MTVisVec[0]+"的歌曲！请等待点歌榜的刷新信息!~");
			
			//判断是否在鱼丸榜内
			db.addEventListener(DataBase.SELECTDB_FORMTV_COMPLETE,selectMTVDBcompleteHandle);
			db.addEventListener(DataBase.SELECTDB_FORMTV_ERROR,selectMTVDBfileHandle);
			db.selectYWId(nextSPItem.id);
			
		}
		//有人点歌  搜索鱼丸榜  成功的fun
		private function selectMTVDBcompleteHandle(evt:Event):void{
			db.removeEventListener(DataBase.SELECTDB_FORMTV_COMPLETE,selectMTVDBcompleteHandle);
			db.removeEventListener(DataBase.SELECTDB_FORMTV_ERROR,selectMTVDBfileHandle);
			db.addEventListener(DataBase.UPDATA_SELECTINFO_COMPLETE,function complete(evt:Event):void{
				db.removeEventListener(DataBase.UPDATA_SELECTINFO_COMPLETE,complete);
				//删除临时表里的此人
				getselectMTVPeopleForId(nextSPItem.id);
				//
				selectRun();
			})
			db.updataMTV(nextSPItem);
		}
		
		private function selectMTVDBfileHandle(evt:Event):void{
			db.removeEventListener(DataBase.SELECTDB_FORMTV_COMPLETE,selectMTVDBcompleteHandle);
			db.removeEventListener(DataBase.SELECTDB_FORMTV_ERROR,selectMTVDBfileHandle);
			updatePeople();
			selectRun();
		}
		
		//修改单独点歌的零时表
		private function updatePeople():void{
			for each (var i:SelectMTVPeople in _selectMTVPeoples) 
			{
				if(i.id==nextSPItem.id){
					i.MTVids=nextSPItem.MTVids;
					i.message=nextSPItem.message;
					return;
				}
			}
			if(_selectMTVPeoples.length>sMTVPMax)return;
			_selectMTVPeoples.push(nextSPItem);
			
		}
		//----------------------------------------------------------------------------------------
        // 送鱼丸的流程		
		//----------------------------------------------------------------------------------------
		private var giftQueyeIsRun:Boolean=false;
		private var nextYWItem:SelectMTVPeople;
		private var _giftQueueArr:Vector.<SelectMTVPeople>=new Vector.<SelectMTVPeople>();
		public function addGiftQueue(giftp:SelectMTVPeople):void{
			_giftQueueArr.push(giftp);
			if(!giftQueyeIsRun){
				giftQueyeIsRun=true;
				giftRun();                        
			}
		}
		private function giftRun():void{
			if(!db){
				db=DataBase.instant;
			}
			nextYWItem=_giftQueueArr.shift();
			if(nextYWItem!=null){
				//
				db.addEventListener(DataBase.SELECTDB_FORGIFT_COMPLETE,giftDBcompleteHandle);
				db.addEventListener(DataBase.SELECTDB_FORGIFT_ERROR,giftDBfileHandle);
				db.selectgiftId(nextYWItem.id);
			}else{
				giftQueyeIsRun=false;
			}
		}
		
		//有人送鱼丸  搜索鱼丸榜 成功的fun
		protected function giftDBcompleteHandle(event:Event):void
		{
			db.removeEventListener(DataBase.SELECTDB_FORGIFT_COMPLETE,giftDBcompleteHandle);
			db.removeEventListener(DataBase.SELECTDB_FORGIFT_ERROR,giftDBfileHandle);
			var currSelectPeople:SelectMTVPeople=getselectMTVPeopleForId(nextYWItem.id);
			db.addEventListener(DataBase.ADD_CURRYW_COMPLETE,function complete(evt:Event):void{
				db.removeEventListener(DataBase.ADD_CURRYW_COMPLETE,complete);
				giftRun();
			});
			if(currSelectPeople!=null){
				currSelectPeople.currYw=nextYWItem.currYw;
				db.updataYWAndSelectMTV(currSelectPeople);
			}else{
				db.updataYW(nextYWItem);
			}
		}
		
		protected function giftDBfileHandle(event:Event):void
		{
			db.removeEventListener(DataBase.SELECTDB_FORGIFT_COMPLETE,giftDBcompleteHandle);
			db.removeEventListener(DataBase.SELECTDB_FORGIFT_ERROR,giftDBfileHandle);
			db.addEventListener(DataBase.INSER_NEW_SELECTPEOPLE_COMPLETE,function complete(evt:Event):void{
				db.removeEventListener(DataBase.INSER_NEW_SELECTPEOPLE_COMPLETE,complete);
				giftRun();
			})
			var currSelectPeople:SelectMTVPeople=getselectMTVPeopleForId(nextYWItem.id);
			if(currSelectPeople!=null){
				currSelectPeople.currYw=nextYWItem.currYw;
				db.insertSelectPeople(currSelectPeople);
			}else{
				db.insertSelectPeople(nextYWItem);
			}
		}
        
		/**
		 * 判断是否已经在点歌榜里了（没给鱼丸的）
		 * @param id
		 * @return 
		 */		
		private function getselectMTVPeopleForId(id:int):SelectMTVPeople
		{
			for (var i:int = 0; i < _selectMTVPeoples.length; i++) 
			{
				if(_selectMTVPeoples[i].id==id){
					var selectPeople:SelectMTVPeople=_selectMTVPeoples.splice(i,1)[0];
				    return selectPeople;
				}
			}
			return null;
		}
		
		//------------------------------------------------------------------------------------
		//************
		//  连播 
		//************
		private var currmvid:int;
		private var selecMvids:String;
		private var currAllowNum:int;
		
		private var _selectContinuityArr:Vector.<SelectMTVPeople>=new Vector.<SelectMTVPeople>(); 
		private var currSelectContinuityPeople:SelectMTVPeople;
		private var selectContinuityIsRun:Boolean=false;
		public function continuity(value:SelectMTVPeople):void{
			_selectContinuityArr.push(value);
			if(!selectContinuityIsRun){
				selectContinuityIsRun=true;
				selectContinuityRun();
			}
		}
		
		private function selectContinuityRun():void
		{
			if(!db){
				db=DataBase.instant;
			}
			currSelectContinuityPeople=_selectContinuityArr.shift();
			if(currSelectContinuityPeople!=null){
				trace("取队列。。。。。。。。。。。。");
				//首先判断此人的鱼丸是否够  点连播的下限值
				db.addEventListener(DataBase.CONTINUITY_CHECK_OK,selectContinuityCompleteHandle);
				db.addEventListener(DataBase.CONTINUITY_CHECK_ERROR,selectContinuityErrorHandle);
				db.checkContinuityPeopleId(currSelectContinuityPeople.id);
			}else{
				trace("完成");
				selectContinuityIsRun=false;
			}
		}		
		
		protected function selectContinuityCompleteHandle(event:Event):void
		{
			db.removeEventListener(DataBase.CONTINUITY_CHECK_OK,selectContinuityCompleteHandle);
			db.removeEventListener(DataBase.CONTINUITY_CHECK_ERROR,selectContinuityErrorHandle);
			//
			currAllowNum=0;
			selecMvids="";
			checkMV();
		}		
		
		protected function selectContinuityErrorHandle(event:Event):void
		{
			db.removeEventListener(DataBase.CONTINUITY_CHECK_OK,selectContinuityCompleteHandle);
			db.removeEventListener(DataBase.CONTINUITY_CHECK_ERROR,selectContinuityErrorHandle);
			selectContinuityRun();
		}
		
	
		private function checkMV():void{
			currmvid=currSelectContinuityPeople.MTVisVec.shift();
			if(currmvid && currAllowNum<db.currContnuityNum){
				db.addEventListener(DataBase.GET_MTV_COMPLETE,ContinuityIfMTVDBcompleteHandle);
				db.addEventListener(DataBase.GET_MTV_ERROR,ContinuityIfMTVDErrorHandle);
				db.selectCheckMVId(currmvid);
			}else{
				if(selecMvids==""||selecMvids==null)return;
				currSelectContinuityPeople.MTVids=selecMvids;
				db.addEventListener(DataBase.CONTINUITYSELECT_OK,continuityOkHandle);
				db.addEventListener(DataBase.CONTINUITYSELECT_ERROR,continuityErrorHandle);
				db.updataContinuitySelectMTV(currSelectContinuityPeople);
			}
		}
		
		protected function continuityOkHandle(event:Event):void
		{
			db.removeEventListener(DataBase.CONTINUITYSELECT_OK,continuityOkHandle);
			db.removeEventListener(DataBase.CONTINUITYSELECT_ERROR,continuityErrorHandle);
			selectContinuityRun();
		}		
		
		protected function continuityErrorHandle(event:Event):void
		{
			db.removeEventListener(DataBase.CONTINUITYSELECT_OK,continuityOkHandle);
			db.removeEventListener(DataBase.CONTINUITYSELECT_ERROR,continuityErrorHandle);
			selectContinuityRun();
		}
		protected function ContinuityIfMTVDBcompleteHandle(event:Event):void
		{
			db.removeEventListener(DataBase.GET_MTV_COMPLETE,ContinuityIfMTVDBcompleteHandle);
			db.removeEventListener(DataBase.GET_MTV_ERROR,ContinuityIfMTVDErrorHandle);
			currAllowNum++;
			if(selecMvids==""){
				selecMvids+=currmvid;
			}else{
				selecMvids+="&"+currmvid;
			}
			checkMV();
		}
		
		protected function ContinuityIfMTVDErrorHandle(event:Event):void
		{
			db.removeEventListener(DataBase.GET_MTV_COMPLETE,ContinuityIfMTVDBcompleteHandle);
			db.removeEventListener(DataBase.GET_MTV_ERROR,ContinuityIfMTVDErrorHandle);
			checkMV();
		}
		//------------------------------------------------------------------------------
		//留言流程
		private var leaveWordArr:Vector.<SelectMTVPeople>=new Vector.<SelectMTVPeople>(); 
		private var currleaveWordPeople:SelectMTVPeople;
		private var leaveWordIsRun:Boolean=false;
		public function leaveWord(value:SelectMTVPeople):void{
			leaveWordArr.push(value);
			if(!leaveWordIsRun){
				leaveWordIsRun=true;
				leaveWordRun();
			}
		}
		
		private function leaveWordRun():void
		{
			if(!db){
				db=DataBase.instant;
			}	
			currleaveWordPeople=leaveWordArr.shift();
			if(currleaveWordPeople){
				db.addEventListener(DataBase.LEAVEWORD_CHANGE_OK,leaveWordComplete);
				db.leaveWord(String(currleaveWordPeople.id),currleaveWordPeople.leaveWord);
			}else{
				leaveWordIsRun=false;
			}
		}
		
		protected function leaveWordComplete(event:Event):void
		{
			leaveWordRun();			
		}
		//
		//
		private var _showMVinfoVes:Vector.<MTVInfo>=new Vector.<MTVInfo>(); 

		public function get showMVinfoVes():Vector.<MTVInfo>
		{
			return _showMVinfoVes;
		}

		public function set showMVinfoVes(value:Vector.<MTVInfo>):void
		{
			_showMVinfoVes = value;
			this.dispatchEvent(new Event(GETMVINFOS_COMPLETE_EVENT));
		}
		
		
		private var _currGetMTV:MTVInfo;

		public function get currGetMTV():MTVInfo
		{
			return _currGetMTV;
		}

		public function set currGetMTV(value:MTVInfo):void
		{
			_currGetMTV = value;
			this.dispatchEvent(new Event(PLAY_MV_COMPLETE));
		}

		private var _currSelectPeople:SelectMTVPeople;

		public function get currSelectPeople():SelectMTVPeople
		{
			return _currSelectPeople;
		}

		public function set currSelectPeople(value:SelectMTVPeople):void
		{
			_currSelectPeople = value;
		}
		
		
		
		
		//提取 前几名 没有送鱼丸的点歌人
		public function getSelectMTVPeopleTop(Num:int):Vector.<SelectMTVPeople>{
			Num=_selectMTVPeoples.length<Num?_selectMTVPeoples.length:Num;
			var tempsp:Vector.<SelectMTVPeople>=new Vector.<SelectMTVPeople>();
			for (var i:int = 0; i < Num; i++) 
			{
				tempsp.push(_selectMTVPeoples[i]);
			}
			return tempsp;
		}
		
		//删除当前 临时表里的 点歌人
		public function delSelectPeople():void{
			_selectMTVPeoples.shift();
		}
		
		private var _TopSelectPeoples:Vector.<SelectMTVPeople>=new Vector.<SelectMTVPeople>();
		//点歌排行榜
		public function get TopSelectPeoples():Vector.<SelectMTVPeople>
		{
			return _TopSelectPeoples;
		}
		
		public function set TopSelectPeoples(value:Vector.<SelectMTVPeople>):void
		{
			if(value){
				_TopSelectPeoples = value;
			}else{
				_TopSelectPeoples=new Vector.<SelectMTVPeople>();
			}
			this.dispatchEvent(new Event(TOP_SELECTMTV_COMPLETE));
		}
		
		
		
//		private var _selectTopMvVector:Vector.<MTVInfo>=new Vector.<MTVInfo>();
//
//		public function get selectTopMvVector():Vector.<MTVInfo>
//		{
//			return _selectTopMvVector;
//		}
//
//		public function set selectTopMvVector(value:Vector.<MTVInfo>):void
//		{
//			_selectTopMvVector=Tools.randomArr(value) as Vector.<MTVInfo>
//			this.dispatchEvent(new Event(SELECT_TOP_MV));
//		}
		
		private var _autoPlayMvNums:Array;

		public function get autoPlayMvNums():Array
		{
			return _autoPlayMvNums;
		}

		public function set autoPlayMvNums(value:Array):void
		{
			_autoPlayMvNums = value;
		}

		
		private var _AutoPlayMvInfo:MTVInfo;

		public function get AutoPlayMvInfo():MTVInfo
		{
			return _AutoPlayMvInfo;
		}

		public function set AutoPlayMvInfo(value:MTVInfo):void
		{
			_AutoPlayMvInfo = value;
			this.dispatchEvent(new Event(SELECT_TOP_MV));
		}
		
		
		private var _topYWVector:Vector.<SelectMTVPeople>=new Vector.<SelectMTVPeople>();
		/**
		 * 土豪榜
		 * @return 
		 */		
		public function get topYWVector():Vector.<SelectMTVPeople>
		{
			return _topYWVector;
		}

		public function set topYWVector(value:Vector.<SelectMTVPeople>):void
		{
			_topYWVector = value;
		}
		
		
		private static var _instant:InfoData;
		
		public static function get instant():InfoData
		{
			if( null == _instant )
			{
				_instant = new InfoData();
			}
			return _instant;
		}
	}
}