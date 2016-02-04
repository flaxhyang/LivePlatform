package douyu.view.showlayer
{
	import flash.display.Sprite;
	import douyu.data.InfoData;
	
	public class SelectMusicTop extends Sprite
	{
		private var infodata:InfoData=InfoData.instant;
		
		public function SelectMusicTop()
		{
			super();
		}
		
		public function Sort():void{
			infodata.rowMusicData
		}
	}
}