package douyu.ctrl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.data.InfoData;
	import douyu.data.vo.MusicData;
	import douyu.view.mp3.MP3Play;
	import douyu.view.mp3.searchmp3.SearchMP3;
	
	public class MP3Ctrl extends EventDispatcher
	{
		
		private var searchmp3:SearchMP3=SearchMP3.instant;
		private var infodata:InfoData=InfoData.instant;
		private var mp3play:MP3Play=MP3Play.instant;
		
		public function MP3Ctrl(target:IEventDispatcher=null)
		{
			super(target);
			init();
		}
		
		public function init():void{
			searchmp3.addEventListener(SearchMP3.SEARCH_MP3_COMPLETE,seatchMp3Complete);
			searchmp3.addEventListener(SearchMP3.SEARCH_MP3_FAILED,seatchMp3Failed);
		}
		
		/**
		 * 搜歌
		 * @param name
		 * @param artist
		 */		
		public function SearchMp3(md:MusicData):void{
			searchmp3.SearchMp3(md);
		}
		protected function seatchMp3Complete(event:Event):void
		{
			infodata.setRowMusicData(searchmp3.currSearchMp3);
		}
		
		protected function seatchMp3Failed(event:Event):void
		{
			infodata.musicNotFind();
		}
		/**
		 * 播放mp3
		 * @param mp3url
		 */		
		public function playMp3(md:MusicData):void{
			mp3play.PlaySound(md);
		}
			
		public function stopMp3():void{
			mp3play.StopSound();
			
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