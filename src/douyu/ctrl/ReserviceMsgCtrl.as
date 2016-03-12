package douyu.ctrl
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.command.ReservicemsgCommand;
	
	public class ReserviceMsgCtrl extends EventDispatcher
	{
		private var rmc:ReservicemsgCommand=ReservicemsgCommand.instant;
		
		public function ReserviceMsgCtrl(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		
		public function msg_decode(id:int,nick:String,msg:String):void{
			rmc.decodeMsg(id,nick,msg);
		}
		
		
		
		private static var _instant:ReserviceMsgCtrl;
		
		public static function get instant():ReserviceMsgCtrl
		{
			if( null == _instant )
			{
				_instant = new ReserviceMsgCtrl();
			}
			return _instant;
		}
	}
}