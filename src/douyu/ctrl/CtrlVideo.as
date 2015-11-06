package douyu.ctrl
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import douyu.video.Stagevideo;
	
	public class CtrlVideo extends EventDispatcher
	{
		private var stageVideo:Stagevideo;
		
		public function CtrlVideo(target:IEventDispatcher=null)
		{
			super(target);
			stageVideo=Stagevideo.instant;
			stageVideo.STREAM_URL="begin.mp4";
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