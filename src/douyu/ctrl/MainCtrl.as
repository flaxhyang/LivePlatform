package douyu.ctrl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import douyu.command.GiftCommand;
	import douyu.command.selectMusicCommand;
	import douyu.data.InfoData;
	import douyu.data.vo.MusicData;
	import douyu.data.vo.PlayerData;
	import douyu.database.DataBase;
	
	public class MainCtrl extends EventDispatcher
	{
		private var ifdt:InfoData;
		private var db:DataBase;
		
		private var ctrlvideo:CtrlVideo=CtrlVideo.instant;
		private var thtopctrl:THTopCtrl=THTopCtrl.instant;
		private var mp3ctrl:MP3Ctrl=MP3Ctrl.instant;
		
		private var smc:selectMusicCommand=selectMusicCommand.instant;
		private var gc:GiftCommand=GiftCommand.instant;
		private var cpmc:CurrPlayerMusicCtrl=CurrPlayerMusicCtrl.instant;
		
		
		
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
				ifdt.autoPlayMvNums=String(mtvlistloader.data).split(",");
				initComplete();
			});
			mtvlistloader.load(Request);
		}
		
		
		//刷新土豪榜
		private function setTHTop():void{
			thtopctrl.getTHData();
		}
		
		//-----------------------------------------------------------ctrl		
		/**
		 *  启动
		 */		
		private function initComplete():void{
			currInitStep++;
			if(currInitStep===initStep){
				ctrlvideo.play("/douyu/view/video/begin.mp4");
				mp3ctrl.init();
				setTHTop();
				cpmc.init();
				//temp
				selectMusic();
			}
		}
		
		
		
		//搜歌 
		public function selectMusic():void{
			
//			return;
			//temp
//			var md:MusicData=new MusicData();
//			md.ismv=true;
////			md.mName="屌丝之歌";
////			md.playerName="花粥";
////			md.ismv=true;
//			md.mvid=301;
//			
//			var sp:PlayerData=new PlayerData();
//			sp.id=212467;
//			sp.nick="flaxhyang";
//			md.selectPlayer=sp;
//			
//			smc.selectMusic(md);
			
			
//			
			
//			return;
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				md.mName="一次就好";
				md.playerName="杨宗纬";
				
				//			md.ismv=true;
				//			md.mvid=301;
				
				var sp:PlayerData=new PlayerData();
				sp.id=212467;
				sp.nick="flaxhyang";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
				
			},10000)
			
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				md.mName="屌丝之歌";
				md.playerName="花粥";
				
				//			md.ismv=true;
				//			md.mvid=301;
				
				var sp:PlayerData=new PlayerData();
				sp.id=9557731;
				sp.nick="不变的调调";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
			},11000);
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
//				md.mName="屌丝之歌";
//				md.playerName="花粥";
				
				md.ismv=true;
				md.mvid=301;
				
				var sp:PlayerData=new PlayerData();
				sp.id=212467;
				sp.nick="flaxhyang";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
				
			},14000)
			
//			return;
			
			
			
			
//			setTimeout(function():void{
//				gc.gift_fish("212467","flaxhyang",9)
//			},9000);
			
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