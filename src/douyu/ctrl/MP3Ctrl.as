package douyu.ctrl
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.command.nextMusic.selectMusicCommand;
	import douyu.data.vo.MusicData;
	import douyu.data.vo.PlayerData;
	import douyu.view.mp3.MP3Play;
	
	public class MP3Ctrl extends EventDispatcher
	{
		private var mp3play:MP3Play=MP3Play.instant;
		private var smc:selectMusicCommand=selectMusicCommand.instant;
		
		public function MP3Ctrl(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function init():void{
			
		}
		
		/**
		 * 搜歌
		 * @param name
		 * @param artist
		 */		
		public function getMp3(md:MusicData):void{
			smc.selectMp3(md);
		}
		
		/**
		 * 播放mp3
		 * @param mp3url
		 */		
		public function playMp3(mp3url:String):void{
			
		}
			
		public function stopMp3():void{
			
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