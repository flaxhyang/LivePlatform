package douyu.robot
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	public class AotuTlak extends EventDispatcher
	{
		private var socketlink:Link=Link.instant;
		
		//轮流标记
		private var s1:int=0; 
		private var s2:int=0;
		
		public function AotuTlak(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		//点歌回答
		/**
		 * 点播成功：
		 * @param talk
		 */		
		public function selectMusicComplete(nick:String,musicid:String):void{
			if(s1>1){
				s1=0;
			}
			if(s1){
				socketlink.sendMsg(nick+"点播成功！请等待点歌榜的刷新信息![emot:dy109]");
			}else{
				socketlink.sendMsg(nick+"[emot:dy109]点播成功了！请等待点歌榜的刷新信息!");
			}
			s1++;
		}
		/**
		 * 没找到此编号的歌曲 
		 */		
		public function noSelectMVNum(musicid:String):void{
			if(s2>1){
				s2=0;
			}
			if(s2){
				socketlink.sendMsg("没有编号为："+musicid+"的歌曲![emot:grief]");
			}else{
				socketlink.sendMsg("[emot:grief]没有编号为："+musicid+"的歌曲!");
			}
			s2++;
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