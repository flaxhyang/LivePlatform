package douyu.ctrl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.data.InfoData;
	import douyu.view.video.Stagevideo;
	
	public class CtrlVideo extends EventDispatcher
	{
		private var stageVideo:Stagevideo=Stagevideo.instant;
		private var infodata:InfoData=InfoData.instant;
		
		
		public function CtrlVideo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function initVideoScreen(completeFun:Function):void{
			stageVideo.addEventListener(Stagevideo.STAGEVIDEO_INITCOMPLETE,function initVideo():void{
				stageVideo.addEventListener(Stagevideo.STOP_VIDEO_EVENT,stopVideoHandle);
				completeFun();
				stageVideo.removeEventListener(Stagevideo.STAGEVIDEO_INITCOMPLETE,initVideo)
			});
			stageVideo.initVideo();
			
		}
		
		public function play(mvurl:String):void{
			stageVideo.visible=true;
			stageVideo.PlayMTV(mvurl);
		}
		
		public function stop():void{
			stageVideo.visible=false;
			stageVideo.stopMTV();
		}
		
		private function stopVideoHandle(event:Event):void{
			infodata.music_stop();
		}
		
		private static var _instant:CtrlVideo;
		public static function get instant():CtrlVideo
		{
			if( null == _instant )
			{
				_instant = new CtrlVideo();
			}
			return _instant;
		}
	}
}