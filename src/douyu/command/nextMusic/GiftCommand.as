package douyu.command.nextMusic
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.ctrl.SelectMusicTopCtrl;
	import douyu.data.InfoData;
	import douyu.data.vo.PlayerData;
	import douyu.database.DataBase;
	
	
	public class GiftCommand extends EventDispatcher
	{
		private var db:DataBase=DataBase.instant;
		private var infodata:InfoData=InfoData.instant;
		private var smtc:SelectMusicTopCtrl=SelectMusicTopCtrl.instant;
		
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
			
			_giftQueueArr.push(player);
			addGift();
		}
		
		private function addGift():void{
			if(!giftQueyeIsRun){
				giftQueyeIsRun=true;
				PlayerItem=_giftQueueArr.shift();
				if(PlayerItem!=null){
					db.addEventListener(DataBase.ADD_YW_COMPLETE,changeComplete);
					db.addYW(PlayerItem);
				}else{
					giftQueyeIsRun=false;	
				}
			}
		}
		
		protected function changeComplete(event:Event):void
		{
			db.removeEventListener(DataBase.ADD_YW_COMPLETE,changeComplete);
			giftQueyeIsRun=false;	
			selectMvSort();
			addGift();
		}
		
		
		private function selectMvSort():void{
			for (var i:int = 0; i < infodata.rowMusicData.length; i++) 
			{
				if(PlayerItem.id==infodata.rowMusicData[i].selectPlayer.id){
					smtc.Sort(i);
					break;
				}
			}
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