package douyu.robot
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	public class AotuTlak extends EventDispatcher
	{
		private var socketlink:Link=Link.instant;
		private var msgs:Vector.<String>=new Vector.<String>();
		private var sendTime:Timer=new Timer(2000);
		private var news:String;
		
		//轮流标记
		private var s1:int=0; 
		private var s2:int=0;
		
		public function AotuTlak(target:IEventDispatcher=null)
		{
			super(target);
			
			sendTime.addEventListener(TimerEvent.TIMER,sendFun);
		}
		
		protected function sendFun(event:TimerEvent):void
		{
			if(msgs.length<=0){
				sendTime.stop();
				return;
			}
			socketlink.sendMsg(msgs.shift());
		}
		
		//点歌回答
		/**
		 * 点播成功：
		 * @param talk
		 */		
		public function selectMusicComplete(nick:String,musicid:String):void{
			var str:String;
			if(s1>1){
				s1=0;
			}
			if(s1){
				str=nick+"点播成功！请等待点歌榜的刷新信息![emot:dy109]";
			}else{
				str=nick+"[emot:dy109]点播成功了！请等待点歌榜的刷新信息!";
			}
			s1++;
			
			sendMsg(str);
		}
		/**
		 * 没找到此编号的歌曲 
		 */		
		public function noSelectMVNum(musicid:String):void{
			var str:String;
			if(s2>1){
				s2=0;
			}
			if(s2){
				str="没有编号为："+musicid+"的歌曲![emot:grief]";
			}else{
				str="[emot:grief]没有编号为："+musicid+"的歌曲!";
			}
			s2++;
			sendMsg(str);
		}
		
		
		/**
		 *
		 * 发送聊天 
		 * 
		 */		
	    public function sendMsg(msg:String):void{
			msgs.push(msg);
			if(!sendTime.running){
				sendTime.start();
			}
		}
		
		
		private static var _instant:AotuTlak;
		
		public static function get instant():AotuTlak
		{
			if( null == _instant )
			{
				_instant = new AotuTlak();
			}
			return _instant;
		}
	}
}