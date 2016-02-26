package douyu.command.nextMusic
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.data.vo.PlayerData;
	
	
	public class GiftCommand extends EventDispatcher
	{
		private var smtc:SelectMuTopCommand=SelectMuTopCommand.instant;
		
		private var giftQueyeIsRun:Boolean=false;
		private var _giftQueueArr:Vector.<PlayerData>=new Vector.<PlayerData>();
		
		private var PlayerItem:PlayerData;
		
		public function GiftCommand(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		
		public function gift_fish(id:String,nick:String,num:int):void{
			var ywNum:Number=num/100;
			var player:PlayerData=new PlayerData();
			player.id=int(id);
			player.nick=nick;
			player.currYW=num;
			
			smtc.addNewOP(player,2);
		}
		
		
		
		
		
		
		private static var _instant:GiftCommand;
		
		public static function get instant():GiftCommand
		{
			if( null == _instant )
			{
				_instant = new GiftCommand();
			}
			return _instant;
		}
	}
}