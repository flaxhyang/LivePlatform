package douyu.view.mp3
{
	import flash.display.Sprite;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	
	import douyu.data.InfoData;
	
	public class MP3background extends Sprite
	{
		private var info:InfoData=InfoData.instant
		private var tw:int;
		private var th:int;
		
		public function MP3background()
		{
			super();
			bgInit();
		}
		
		private function bgInit():void{
			tw=info.sgWidth;
			th=info.sgHeight;
			
			var directory:File = new File();
			var urlStr:String = "file:///"+InfoData.MP3BackGroundImage;
			directory.url = urlStr;
//			directory.getDirectoryListing();
			var contents:Array=directory.getDirectoryListing();
			
			for (var i:uint = 0; i < contents.length; i++)
			{
				trace(contents[i].name);
				trace(contents[i].type);
			}
//			directory.addEventListener(FileListEvent.DIRECTORY_LISTING, dirListHandler);
		}
		
		
		
		private static var _instant:MP3background;
		
		public static function get instant():MP3background
		{
			if( null == _instant )
			{
				_instant = new MP3background();
			}
			return _instant;
		}
	}
}