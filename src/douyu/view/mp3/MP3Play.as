package douyu.view.mp3
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class MP3Play extends Sprite
	{
		private var baidump3:GetBaiduMP3=GetBaiduMP3.instant;
		private var xiamimp3:GetXiaMiMP3=GetXiaMiMP3.instant;
		
		public function MP3Play()
		{
			super();
		}
		public function init():void{
			
		}
		
		public function getMp3(name:String,artist:String):void{
//			baidump3.addEventListener(GetBaiduMP3.FINd_OK,mp3CompleteHanlde);
//			baidump3.addEventListener(GetBaiduMP3.NotFind_MP3,baiduMp3Error);
//			baidump3.getMp3(name,artist);
			xiamimp3.getMp3(name,artist);
		}
		
		protected function baiduMp3Error(event:Event):void
		{
						
		}
		
		protected function mp3CompleteHanlde(event:Event):void
		{
			
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