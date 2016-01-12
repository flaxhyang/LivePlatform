package douyu.ctrl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.data.InfoData;
	import douyu.data.vo.MusicData;
	import douyu.view.mp3.searchmp3.SearchMP3;
	
	public class MP3Ctrl extends EventDispatcher
	{
		public static const SEARCHMP3_PROCESS_COMPLETE:String="searchMP3_process_complete";
		
		private var searchmp3:SearchMP3=SearchMP3.instant;
		private var infodata:InfoData=InfoData.instant;
		
		public function MP3Ctrl(target:IEventDispatcher=null)
		{
			super(target);
			init();
		}
		
		public function init():void{
			this.addEventListener(SearchMP3.SEARCH_MP3_COMPLETE,seatchMp3Complete);
			this.addEventListener(SearchMP3.SEARCH_MP3_FAILED,seatchMp3Failed);
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
			//发消息
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