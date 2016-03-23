package douyu.ctrl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.robot.AotuTlak;
	
	
	public class LinkTM extends EventDispatcher
	{
		
		private var ywctrl:YWCtrl=YWCtrl.instant;
		private var rmc:ReserviceMsgCtrl=ReserviceMsgCtrl.instant;
		
		private var socket:Link=Link.instant;
		
		private var at:AotuTlak=AotuTlak.instant;
		
		public function LinkTM(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function linkInit():void{
			trace("link .......................")
			
			//			socket.setTHwelcome(welcomefun);
			socket.setGetMsg(rmc.msg_decode);
			socket.setGift(ywctrl.addYW);
			
			socket.addEventListener(Link.LINK_OK,isLinkHandle);
			
			//longlong 194257
			//me 193466
			socket.initService(193466);
		}
		
		public function sendMsg(msg:String):void{
			socket.sendMsg(msg);
		}
		
		private function isLinkHandle(event:Event):void
		{
			socket.removeEventListener(Link.LINK_OK,isLinkHandle);
			
			at.sendMsg("连接ok");

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