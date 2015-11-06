package douyu.ctrl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import douyu.database.DataBase;
	import douyu.video.Stagevideo;
	import douyu.vo.InfoData;
	
	public class MainCtrl extends EventDispatcher
	{
		private var ifdt:InfoData;
		private var db:DataBase;
		private var sv:Stagevideo;
		
		public function MainCtrl(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		private const initStep:int=3;//启动总步骤
		private var currInitStep:int=0;//当前启动完成步骤
		
		
		public function LiveInit():void{
			ifdt=InfoData.instant;
			db=DataBase.instant;
			sv=Stagevideo.instant;
		    
			initDataBase();//连接数据表
			initStageVideo();//init stagevideo
			getAutoMvlist();//获取自动播放列表
		}
		
		
		/**
		 *  启动
		 */		
		private function initComplete():void{
			currInitStep++;
			if(currInitStep===initStep){
				sv.PlayMTV("/video/begin.mp4");
			}
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
			sv.addEventListener(Stagevideo.STAGEVIDEO_INITCOMPLETE,function initVideo():void{
				sv.removeEventListener(Stagevideo.STAGEVIDEO_INITCOMPLETE,initVideo)
				initComplete();
			});
			sv.addEventListener(Stagevideo.STOP_VIDEO_EVENT,nextVideo);
			sv.initVideo();
			
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
		
		
		//-----------------------------------------------------------ctrl		
		protected function nextVideo(event:Event):void
		{
			
		}
		
		
		
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