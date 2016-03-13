package douyu.ctrl
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import douyu.command.GiftCommand;
	import douyu.robot.AotuTlak;
	
	
	public class YWCtrl extends EventDispatcher
	{
		private var gc:GiftCommand=GiftCommand.instant;
		private var at:AotuTlak=AotuTlak.instant;
		
		private var TankTimer:Timer=new Timer(3000);
		private var THTempVec:Vector.<TTHVo>=new Vector.<TTHVo>();
		private var currTankNum:uint=0;
		
		public function YWCtrl(target:IEventDispatcher=null)
		{
			super(target);
			setAutoThank();
		}
		
		/**
		 * 接收鱼丸 
		 * @param id
		 * @param nick
		 * @param num
		 * 
		 */		
		public function addYW(id:String,nick:String,num:int):void{
			giftTank(int(id),nick,num);
		}
		
		
		
		//自动答谢鱼丸的
		
		private function setAutoThank():void
		{
			TankTimer.addEventListener(TimerEvent.TIMER,function tankTimerHandle(event:TimerEvent):void{
				if(THTempVec.length<=0){
					TankTimer.stop();
					return;
				}
				var currth:TTHVo=THTempVec.shift();
				var msg:String;
				if(currTankNum>1){
					currTankNum=0;
				}
				if(currth.yuNum>10){
					if(currTankNum){
						msg="哭天！喊地！感谢！"+currth.thName+" 大土豪的"+int(currth.yuNum*100)+"鱼丸！[emot:grief]";
					}else{
						msg="哭天！喊地！感谢！"+currth.thName+" 大土豪的"+int(currth.yuNum*100)+"鱼丸[emot:grief][emot:grief]";
					}
				}else if(currth.yuNum>5){
					if(currTankNum){
						msg="热泪感谢！"+currth.thName+" 大土豪的"+int(currth.yuNum*100)+"鱼丸！[emot:kx]";
					}else{
						msg="热泪感谢！"+currth.thName+" 大土豪的"+int(currth.yuNum*100)+"鱼丸[emot:kx][emot:kx]";
					}
				}else{
					if(currTankNum){
						msg="感谢！ "+currth.thName+" 土豪的 "+int(currth.yuNum*100)+"鱼丸！[emot:excited]";
					}else{
						msg="感谢！ "+currth.thName+" 土豪的 "+int(currth.yuNum*100)+"鱼丸[emot:excited][emot:excited]";
					}
				}
				currTankNum++;	
				
				gc.gift_fish(currth.id,currth.thName,currth.yuNum);
				at.sendMsg(msg);
			});
		}	
		private function giftTank(playerid:int,nick:String,ywnum:Number):void{
			
			var ywNum:Number=ywnum/100;
			
			if(!THTempVec.length){
				pushNewth(playerid,nick,ywNum);
			}else{
				var isnew:Boolean=true;
				for (var i:int = 0; i < THTempVec.length; i++) 
				{
					if(playerid==THTempVec[i].id){
						THTempVec[i].yuNum+=ywNum;
						isnew=false;
						break;
					}
				}
				if(isnew){
					pushNewth(playerid,nick,ywNum);	
				}
			}
			
			if(TankTimer.running){
				TankTimer.reset();
			}
			
			TankTimer.start();
			
		}
		private function pushNewth(id:int,nick:String,ywNum:Number):void{
			var thvo:TTHVo=new TTHVo();
			thvo.id=id;
			thvo.thName=nick;
			thvo.yuNum+=ywNum;
			THTempVec.push(thvo);
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

class TTHVo{
	private var _id:int;
	
	public function get id():int
	{
		return _id;
	}
	
	public function set id(value:int):void
	{
		_id = value;
	}
	
	
	private var _thName:String;
	
	public function get thName():String
	{
		return _thName;
	}
	
	public function set thName(value:String):void
	{
		_thName = value;
	}
	
	private var _yuNum:Number=0;
	
	public function get yuNum():Number
	{
		return _yuNum;
	}
	
	public function set yuNum(value:Number):void
	{
		_yuNum = value;
	}
}
