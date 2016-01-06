package douyu.ctrl
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.view.mp3.MP3Play;
	
	public class MP3Ctrl extends EventDispatcher
	{
		private var mp3play:MP3Play=MP3Play.instant;
		
		public function MP3Ctrl(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function init():void{
			mp3play.getMp3("","");
		}
			
		
		private static var _instant:MP3Ctrl;
		
		public static function get instant():MP3Ctrl
		{
			if( null == _instant )
			{
				_instant = new MP3Ctrl();
			}
			return _instant;
		}
	}
}