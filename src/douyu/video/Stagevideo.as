package douyu.video
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import douyu.vo.InfoData;
	
	
	public class Stagevideo extends Sprite
	{
		
		public static const STOP_VIDEO_EVENT:String="stop_video_event";
		
		private var _STREAM_URL:String;

		public function get STREAM_URL():String
		{
			return _STREAM_URL;
		}


		public function set STREAM_URL(value:String):void
		{
			_STREAM_URL = value;
		}

		private var netConnection:NetConnection;
		private var netStream:NetStream;
		private var svideo:StageVideo;
		private var addedToStage:Boolean;
		private var svEnabled:Boolean;
		
		private var VideNewW:int;
		

		public function Stagevideo()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, onAvail);			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAvail(event:StageVideoAvailabilityEvent):void{
			if(event.availability == StageVideoAvailability.AVAILABLE){
				svEnabled = true;
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
		}
		
	
		
		private function onConnectionNetStatus(event:NetStatusEvent):void {
			switch(event.info.code)
			{
				case "NetConnection.Connect.Success":
				{
					startStream();
					break;
				}
				case "NetStream.Play.Start":
				{
					trace("start")
					break;
				}
				case "NetStream.Play.Stop":
				{
					trace("stop")
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
			svideo = stage.stageVideos[0];
		
			svideo.attachNetStream(netStream);
			
			VideNewW=stage.stageWidth-InfoData.TopListWidth;
			svideo.viewPort = new Rectangle(0, 0, VideNewW, stage.stageHeight);
			
			netStream.play(STREAM_URL);
		}
		
		protected function _metaDataHandler(info:Object):void {
			this.metaData = info;
			if(info.height>info.width){
				var VideW:int=int(info.width*stage.stageHeight/info.height);
				var newX:Number=VideNewW-VideW>>1;
				svideo.viewPort = new Rectangle(newX, 0, VideW, stage.stageHeight);
			}else{
				svideo.viewPort = new Rectangle(0, 0, stage.stageWidth-InfoData.TopListWidth, stage.stageHeight);
			}
			
		}
		
		protected function _cuePointHandler(info:Object):void {
			
		}


		public function PlayMTV(mtv:String):void{
			trace("mtv="+mtv);
			netStream.play("/videos/begin.mp4");
//			netStream.play(mtv);
		
		}
		
		public function stopMTV():void{
			netStream.close();
			this.dispatchEvent(new Event(STOP_VIDEO_EVENT));
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