package douyu.ctrl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import douyu.data.InfoData;
	import douyu.data.vo.MusicData;
	import douyu.data.vo.PlayerData;
	import douyu.database.DataBase;
	import douyu.tool.Tools;
	
	public class MainCtrl extends EventDispatcher
	{
		private var ifdt:InfoData;
		private var db:DataBase;
		
		private var ctrlvideo:CtrlVideo=CtrlVideo.instant;
		private var thtopctrl:THTopCtrl=THTopCtrl.instant;
		private var mp3ctrl:MP3Ctrl=MP3Ctrl.instant;
		private var link:LinkTM=LinkTM.instant;
		
		
//		private var smc:selectMusicCommand=selectMusicCommand.instant;
//		private var gc:GiftCommand=GiftCommand.instant;
		private var cpmc:CurrPlayerMusicCtrl=CurrPlayerMusicCtrl.instant;
		private var ac:AuthorityCtrl=AuthorityCtrl.instant;
		
		
		
		
		public function MainCtrl(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		private const initStep:int=3;//启动总步骤
		private var currInitStep:int=0;//当前启动完成步骤
		
		
		public function LiveInit():void{
			ifdt=InfoData.instant;
			db=DataBase.instant;
			
		    
			initDataBase();//连接数据表
			initStageVideo();//init stagevideo
			getAutoMvlist();//获取自动播放列表
			authorityCtrl();//获取超级权限列表
			
			
			//
//			ifdt.playMusicdata=new MusicData();
		}
		
		
		
		//数据库连接
		private function initDataBase():void{
			db.addEventListener(DataBase.LINK_DATABASE_COMPLETE,function databaseComplete():void{
				initComplete();
			});
			db.openDatabase();
		}
		
		//stagevideo init
		private function initStageVideo():void{
			ctrlvideo.initVideoScreen(initComplete);
		}
		
		//获取自动播放列表
		private function getAutoMvlist():void{
			var mtvlistloader:URLLoader=new URLLoader();
			var Request:URLRequest=new URLRequest(InfoData.MTVListURL);
			mtvlistloader.addEventListener(Event.COMPLETE,function blackwordhandle():void{
				ifdt.autoPlayMvNums=Tools.getRandomArr(String(mtvlistloader.data).split(","));
				initComplete();
			});
			mtvlistloader.load(Request);
		}
		
		
		//刷新土豪榜
		private function setTHTop():void{
			thtopctrl.getTHData();
		}
		
		
		private function authorityCtrl():void
		{
			ac.init();			
		}
		
		//-----------------------------------------------------------ctrl		
		/**
		 *  启动
		 */		
		private function initComplete():void{
			currInitStep++;
			if(currInitStep===initStep){
				var beginMD:MusicData=new MusicData();
				beginMD.ismv=true;
				ifdt.playMusicdata=beginMD;
				ctrlvideo.play(InfoData.initVideoURL);
				mp3ctrl.init();
				setTHTop();
				cpmc.init();
				link.linkInit();
				//temp
				selectMusic();
			}
		}
		
		//搜歌 
		public function selectMusic():void{

			
		}
		
		
		
		
		//----------------------------------------------------------time
		
		
		
		private static var _instant:MainCtrl;
		
		public static function get instant():MainCtrl
		{
			if( null == _instant )
			{
				_instant = new MainCtrl();
			}
			return _instant;
		}
	}
}