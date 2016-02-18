package douyu.view.mp3.searchmp3
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import douyu.data.vo.MusicData;
	
	
	public class SearchMP3 extends Sprite
	{
		
		public static const SEARCH_MP3_COMPLETE:String="search_mp3_complete";
		public static const SEARCH_MP3_FAILED:String="search_mp3_failed";
		
		private var baidump3:GetBaiduMP3=GetBaiduMP3.instant;
		private var xiamimp3:GetXiaMiMP3=GetXiaMiMP3.instant;
		
	
		
		public var currSearchMp3:MusicData;
		
		
		
		public function SearchMP3()
		{
			super();
		}
		public function init():void{
			
		}
		
		public function SearchMp3(md:MusicData):void{
			currSearchMp3=md;
			baidump3.addEventListener(GetBaiduMP3.FINd_OK,mp3CompleteHanlde);
			baidump3.addEventListener(GetBaiduMP3.NotFind_MP3,baiduMp3Error);
			baidump3.getMp3(currSearchMp3.mName,currSearchMp3.playerName);
		}
		
		protected function baiduMp3Error(event:Event):void
		{
			xiamimp3.addEventListener(GetXiaMiMP3.FINd_OK,mp3CompleteHanlde);
			xiamimp3.addEventListener(GetXiaMiMP3.NotFind_MP3,notFindMpsHandle);
			xiamimp3.getMp3(currSearchMp3.mName,currSearchMp3.playerName);
		}
		
		protected function notFindMpsHandle(event:Event):void
		{
			this.dispatchEvent(new Event(SEARCH_MP3_FAILED));
		}
		
		protected function mp3CompleteHanlde(event:Event):void
		{
			var newMusic:MusicData=(event.target).selestMusic;
			currSearchMp3.mName=newMusic.mName;
			currSearchMp3.musicUrl=newMusic.musicUrl;
			currSearchMp3.playerName=newMusic.playerName;
			this.dispatchEvent(new Event(SEARCH_MP3_COMPLETE));
		}		
		
		
		private static var _instant:SearchMP3;
		
		public static function get instant():SearchMP3
		{
			if( null == _instant )
			{
				_instant = new SearchMP3();
			}
			return _instant;
		}
	}
}