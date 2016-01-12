package douyu.command.nextMusic
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.ctrl.MP3Ctrl;
	import douyu.data.vo.MusicData;
	
	
	public class selectMusicCommand extends EventDispatcher
	{

		private var isSelecting:Boolean=false;
		
		private var TempSelectPlayerRow:Vector.<MusicData>=new Vector.<MusicData>();
		
		private var mp3ctrl:MP3Ctrl=MP3Ctrl.instant;
		
		public function selectMusicCommand(target:IEventDispatcher=null)
		{
			super(target);
			init();
		}
		
		private function init():void{
			mp3ctrl.addEventListener(MP3Ctrl.SEARCHMP3_PROCESS_COMPLETE,seatchMp3Complete);
		}
		
		protected function seatchMp3Complete(event:Event):void
		{
			isSelecting=false;
			if(TempSelectPlayerRow.length){
				nextMusic();
			}
		}
		
		
		
		public function selectMusic(md:MusicData):void{
			TempSelectPlayerRow.push(md);
			if(!isSelecting){
				nextMusic();
			}
		}
		
		private function nextMusic():void{
			var tmd:MusicData=TempSelectPlayerRow.shift();
			if(tmd.ismv){
			
			}else{
				mp3ctrl.SearchMp3(tmd);
			}
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