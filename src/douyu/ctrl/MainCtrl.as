package douyu.ctrl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import douyu.data.InfoData;
	import douyu.data.vo.MusicData;
	import douyu.database.DataBase;
	
	public class MainCtrl extends EventDispatcher
	{
		private var ifdt:InfoData;
		private var db:DataBase;
		
		private var ctrlvideo:CtrlVideo=CtrlVideo.instant;
		private var thtopctrl:THTopCtrl=THTopCtrl.instant;
		private var mp3ctrl:MP3Ctrl=MP3Ctrl.instant;
		
		
		
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
			ifdt.playMusicdata=new MusicData();
			ifdt.playMusicdata.ismv=true;
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
				ctrlvideo.play("/douyu/video/begin.mp4");
				mp3ctrl.init();
				setTHTop();
				//
				ifdt.addEventListener(InfoData.MUSIC_PLAY_COMPLETE,musicPlayComplete);
				ifdt.addEventListener(InfoData.ROW_MUSIC_CHANGE,NewMusicSelectHandle);
				
				//temp
				var md:MusicData=new MusicData();
				md.ismv=false;
				md.mName="一次就好";
				md.playerName="杨宗纬";
				mp3ctrl.SearchMp3(md);
			}
		}
		
		protected function musicPlayComplete(event:Event):void
		{
			PlayMusic();
		}
		
		protected function NewMusicSelectHandle(event:Event):void
		{
			var isStop:Boolean=false;
			if(ifdt.playMusicdata.selectPlayer==null){
				isStop=true;
			}				
			
			if(ifdt.playMusicdata.selectPlayer!=null && ifdt.playMusicdata.listSelectPlayer==true){
				isStop=true;
			}
			
			if(isStop){
				if(ifdt.playMusicdata.ismv){
					ctrlvideo.stop();					
				}else{
					mp3ctrl.stopMp3();
				}
			}
		}		
		
		//------------------------------------play  music
		private function PlayMusic():void{
			if(ifdt.rowMusicData.length>0){
				var md:MusicData=ifdt.rowMusicData.shift();
					if(md.ismv){
						ctrlvideo.play("/douyu/video/begin.mp4");
					}else{
						mp3ctrl.playMp3(md);
					}
			}else{
				ctrlvideo.play("/douyu/video/begin.mp4");
			}
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