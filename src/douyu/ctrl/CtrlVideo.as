package douyu.ctrl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.video.Stagevideo;
	
	public class CtrlVideo extends EventDispatcher
	{
		private var stageVideo:Stagevideo=Stagevideo.instant;
		
		public function CtrlVideo(target:IEventDispatcher=null)
		{
			super(target);
			stageVideo.addEventListener(Stagevideo.STOP_VIDEO_EVENT,nextVideo);
		}
		
		private function nextVideo(event:Event):void{
			//temp
			play("/douyu/video/begin.mp4");
		}
		
		
		public function play(mvurl:String):void{
			stageVideo.PlayMTV(mvurl);
		}
		
		public function stop():void{
			stageVideo.stopMTV();
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