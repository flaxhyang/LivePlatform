package douyu.command
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.ctrl.THTopCtrl;
	import douyu.data.vo.PlayerData;
	
	
	public class GiftCommand extends EventDispatcher
	{
		private var smtc:SelectMuTopCommand=SelectMuTopCommand.instant;
		private var tht:THTopCtrl=THTopCtrl.instant;
		
		private var giftQueyeIsRun:Boolean=false;
		private var _giftQueueArr:Vector.<PlayerData>=new Vector.<PlayerData>();
		
		private var PlayerItem:PlayerData;
		
		public function GiftCommand(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * 加鱼丸 
		 * @param id
		 * @param nick
		 * @param num
		 * 
		 */		
		public function gift_fish(id:String,nick:String,num:int):void{
			var ywNum:Number=num/100;
			var player:PlayerData=new PlayerData();
			player.id=int(id);
			player.nick=nick;
			player.OPerationAddYW=num;
			
			smtc.addNewOP(player,2);
		}
		
		
		/**
		 *点歌 扣鱼丸  
		 */		
		public function cutYWForSelect(pd:PlayerData,ywnum:uint):void{
			if(!tht.isTH(pd.id)){
				pd.OperationCutYW=ywnum;
				smtc.addNewOP(pd,4);
			}
		}
		
		
		/**
		 * 减鱼丸 
		 * @param pd
		 * @ywnum
		 */		
		public function cutYW(pd:PlayerData,ywnum:uint):void{
			var playerdata:PlayerData=pd;
			playerdata.OperationCutYW=ywnum;
			smtc.addNewOP(playerdata,3);
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