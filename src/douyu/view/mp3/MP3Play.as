package douyu.view.mp3
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import douyu.command.nextMusic.selectMusicCommand;
	
	
	public class MP3Play extends Sprite
	{
		private var baidump3:GetBaiduMP3=GetBaiduMP3.instant;
		private var xiamimp3:GetXiaMiMP3=GetXiaMiMP3.instant;
		
		private var playerName:String;
		private var artist:String;
		
		private var smc:selectMusicCommand=selectMusicCommand.instant;
		
		public function MP3Play()
		{
			super();
		}
		public function init():void{
			
		}
		
		public function getMp3(name:String,artist:String):void{
			this.playerName=name;
			this.artist=artist;
			baidump3.addEventListener(GetBaiduMP3.FINd_OK,mp3CompleteHanlde);
			baidump3.addEventListener(GetBaiduMP3.NotFind_MP3,baiduMp3Error);
			baidump3.getMp3(this.playerName,this.artist);
		}
		
		protected function baiduMp3Error(event:Event):void
		{
			xiamimp3.addEventListener(GetXiaMiMP3.FINd_OK,mp3CompleteHanlde);
			xiamimp3.addEventListener(GetXiaMiMP3.NotFind_MP3,notFindMpsHandle);
			xiamimp3.getMp3(this.playerName,this.artist);
		}
		
		protected function notFindMpsHandle(event:Event):void
		{
			
		}
		
		protected function mp3CompleteHanlde(event:Event):void
		{
			(event.target).selestMusic
		}		
		
		
		private static var _instant:MP3Play;
		
		public static function get instant():MP3Play
		{
			if( null == _instant )
			{
				_instant = new MP3Play();
			}
			return _instant;
		}
	}
}