package douyu.ctrl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class LinkTM extends EventDispatcher
	{
		
		private var socket:Link=Link.instant;
		
		public function LinkTM(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function linkInit():void{
			socket.addEventListener(Link.LINK_OK,isLinkHandle);
//			socket.initService(193466);
		}
		
		public function sendMsg(msg:String):void{
			socket.sendMsg(msg);
		}
		
		private function isLinkHandle(event:Event):void
		{
			socket.removeEventListener(Link.LINK_OK,isLinkHandle);
//			socket.setTHwelcome(welcomefun);
//			socket.setGetMsg(msg_decode);
//			socket.setGift(gift_fish);
		}
		
		
		private static var _instant:LinkTM;
		public static function get instant():LinkTM
		{
			if( null == _instant )
			{
				_instant = new LinkTM();
			}
			return _instant;
		}
	}
}