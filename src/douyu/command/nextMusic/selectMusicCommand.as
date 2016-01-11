package douyu.command.nextMusic
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.data.vo.MusicData;
	import douyu.data.vo.PlayerData;
	import douyu.view.mp3.MP3Play;
	
	
	public class selectMusicCommand extends EventDispatcher
	{
		public static const SELECTMUSIC_COMPLETE:String="selectMusic_complete";
		public static const SELECTMUSIC_FAILED:String="selectMusic_failed";
		
		private var isSelecting:Boolean=false;
		
		private var TempSelectPlayerRow:Vector.<MusicData>=new Vector.<MusicData>();
		
		private var mp3play:MP3Play=MP3Play.instant;
		
		public function selectMusicCommand(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function selectMp3(md:MusicData):void{
			if(isSelecting){
				TempSelectPlayerRow.push(md);
			}else{
				mp3play.getMp3(md.mName,md.playerName);
			}
		}
		
		
		
		private function dispatchComplete():void{
			this.dispatchEvent(new Event(SELECTMUSIC_COMPLETE));
		}
		
		private function dispatchFailed():void{
			this.dispatchEvent(new Event(SELECTMUSIC_FAILED));
		}
		
		
		
		private static var _instant:selectMusicCommand;
		
		public static function get instant():selectMusicCommand
		{
			if( null == _instant )
			{
				_instant = new selectMusicCommand();
			}
			return _instant;
		}
	}
}