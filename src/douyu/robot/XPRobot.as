package douyu.robot
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import douyu.data.InfoData;
	

	public class XPRobot
	{
		private const interval:int=60000;
		private var sendMsgTimer:Timer=new Timer(interval);
		private var at:AotuTlak=AotuTlak.instant;
		
		
		public function XPRobot()
		{
			var wordsVec:Array;
			var currwordNum:int=0;
			var textload:URLLoader=new URLLoader();
			var txtURLRequest:URLRequest=new URLRequest(InfoData.AUTOMSGURL);
			textload.addEventListener(Event.COMPLETE,function wordHandle(evt:Event):void{
				wordsVec=String(textload.data).split("\r\n");
				sendMsgTimer=new Timer(interval);
				sendMsgTimer.addEventListener(TimerEvent.TIMER,function sendmsgHandle(event:TimerEvent):void
				{
					if(currwordNum>=wordsVec.length){
						currwordNum=0;
					}
					at.sendMsg(wordsVec[currwordNum]);
					currwordNum++;			
				});
				
				
			});
			textload.load(txtURLRequest);
		}
		
		public function MPStart():void{
			sendMsgTimer.start();
		}
		
		public function MPStop():void{
			sendMsgTimer.stop();	
		}
		
		
		
		
		private static var _instant:XPRobot;
		
		public static function get instant():XPRobot
		{
			if( null == _instant )
			{
				_instant = new XPRobot();
			}
			return _instant;
		}
	}
}