package douyu.ctrl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.data.InfoData;
	import douyu.view.showlayer.MusicInfo;
	
	public class CurrPlayerMusicCtrl extends EventDispatcher
	{
		private var infodata:InfoData=InfoData.instant;
		private var musicinfo:MusicInfo=MusicInfo.instant;
		
		public function CurrPlayerMusicCtrl(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function init():void{
			infodata.addEventListener(InfoData.MUSIC_PLAYING_EVENT,playingMusicHnadle);
		}
		
		protected function playingMusicHnadle(event:Event):void
		{
			musicinfo.showInfo(infodata.playMusicdata);		
		}		
		
		private static var _instant:CurrPlayerMusicCtrl;
		public static function get instant():CurrPlayerMusicCtrl
		{
			if( null == _instant )
			{
				_instant = new CurrPlayerMusicCtrl();
			}
			return _instant;
		}
	}
}