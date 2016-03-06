package douyu.command
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ReservicemsgCommand extends EventDispatcher
	{
		private var currid:int;
		private var currnick:String;
		
		public function ReservicemsgCommand(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function decodeMsg(id:String,nick:String,msg:String):void{
			currid=int(id);
			currnick=nick;
			
		}
		
		
		
		private static var _instant:ReservicemsgCommand;
		
		public static function get instant():ReservicemsgCommand
		{
			if( null == _instant )
			{
				_instant = new ReservicemsgCommand();
			}
			return _instant;
		}
	}
}