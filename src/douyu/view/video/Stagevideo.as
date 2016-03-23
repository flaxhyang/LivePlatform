package douyu.view.video
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class Stagevideo extends Sprite
	{
		
		public static const STOP_VIDEO_EVENT:String="stop_video_event";
		public static const STAGEVIDEO_INITCOMPLETE:String="stagevideo_initcomplete";
		
		

		private var netConnection:NetConnection;
		private var netStream:NetStream;
		private var svideo:StageVideo;
		private var addedToStage:Boolean;
		private var svEnabled:Boolean=false;
		
		private var VideNewW:int;
		
		private var sg:Stage;
		

		public function Stagevideo()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		private function onAddedToStage(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			sg=this.stage;
//			trace(sg);
		}
		
		public function initVideo():void{
			sg.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onAvail);			
		}
		
		protected function onAvail(event:StageVideoAvailabilityEvent):void{
//			trace(event.availability)
			if(event.availability == StageVideoAvailability.AVAILABLE){
				svEnabled = true;
			}else{
				trace("不支持设备");
			}
			connectStream();
		}
		
		private function connectStream():void {
			if (!svEnabled)
				return;
			netConnection = new NetConnection();
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, onConnectionNetStatus);
			netConnection.addEventListener("asyncError", _failHandler);
			netConnection.addEventListener("securityError", _failHandler);
			netConnection.connect(null);
		}
		
		protected function _failHandler(event:Event):void
		{
			trace("error")
			this.dispatchEvent(new Event(STOP_VIDEO_EVENT));
		}
		
	
		
		private function onConnectionNetStatus(event:NetStatusEvent):void {
			switch(event.info.code)
			{
				case "NetConnection.Connect.Success":
				{
					this.dispatchEvent(new Event(STAGEVIDEO_INITCOMPLETE));
					startStream();
					break;
				}
				case "NetStream.Play.Start":
				{
//					trace("start")
					break;
				}
				case "NetStream.Play.Stop":
				{
//					trace("stop mv")
					this.dispatchEvent(new Event(STOP_VIDEO_EVENT));
					break;
				}
				case "NetStream.Play.StreamNotFound":
				{
					trace("StreamNotFound")
					this.dispatchEvent(new Event(STOP_VIDEO_EVENT));
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		private function startStream():void {
			netStream = new NetStream(netConnection);
			netStream.addEventListener(NetStatusEvent.NET_STATUS, onConnectionNetStatus);
			netStream.addEventListener("ioError", _failHandler);
			netStream.addEventListener("asyncError", _failHandler);
			
//			netStream.client = this;
			netStream.client = {onMetaData:_metaDataHandler, onCuePoint:_cuePointHandler};
			svideo = sg.stageVideos[0];
		
			svideo.attachNetStream(netStream);
			
			svideo.viewPort = new Rectangle(0, 0, sg.stageWidth, sg.stageHeight);
			
		}
		
		protected function _metaDataHandler(info:Object):void {
			if(info.height>info.width){
				var VideW:int=int(info.width*sg.stageHeight/info.height);
				var newX:Number=VideNewW-VideW>>1;
				svideo.viewPort = new Rectangle(newX, 0, VideW, sg.stageHeight);
			}else{
				svideo.viewPort = new Rectangle(0, 0, sg.stageWidth, sg.stageHeight);
			}
			
		}
		
		protected function _cuePointHandler(info:Object):void {
			
		}


		public function PlayMTV(mtv:String):void{
			netStream.play(mtv);
		}
		
		public function stopMTV():void{
			netStream.close();
//			this.dispatchEvent(new Event(STOP_VIDEO_EVENT));
		}
		
		private static var _instant:Stagevideo;
	
		public static function get instant():Stagevideo
		{
			if( null == _instant )
			{
				_instant = new Stagevideo();
			}
			return _instant;
		}
	}
}