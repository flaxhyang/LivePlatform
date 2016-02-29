package douyu.ctrl
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.command.GiftCommand;
	
	public class YWCtrl extends EventDispatcher
	{
		private var gc:GiftCommand=GiftCommand.instant;
		
		public function YWCtrl(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * 接收鱼丸 
		 * @param id
		 * @param nick
		 * @param num
		 * 
		 */		
		public function addYW(id:String,nick:String,num:int):void{
			gc.gift_fish(id,nick,num);
		}
		
		
		private static var _instant:YWCtrl;
		public static function get instant():YWCtrl
		{
			if( null == _instant )
			{
				_instant = new YWCtrl();
			}
			return _instant;
		}
	}
}