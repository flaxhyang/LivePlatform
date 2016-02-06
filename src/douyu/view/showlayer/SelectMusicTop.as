package douyu.view.showlayer
{
	import flash.display.Sprite;
	
	import douyu.data.InfoData;
	import douyu.data.vo.MusicData;
	
	public class SelectMusicTop extends Sprite
	{
		private var infodata:InfoData=InfoData.instant;
		
		private const showMaxNo:uint=10;
		
		private var sortintSum:int=0;
		private var isSorting:Boolean=false;
		
		private var currSortMd:MusicData;
		
		public function SelectMusicTop()
		{
			super();
		}
		
		public function Sort():void{
			sortintSum++;
			if(!isSorting){
				sorting();
			}
		}
		
		private function sorting():void{
			isSorting=true;
			if(infodata.rowMusicData.length<2){
				sortintSum=0;
				isSorting=false;
				return;
			}
			
			if(sortintSum>0){
				sortintSum--;
				currSortMd=infodata.rowMusicData[infodata.rowMusicData.length-1];
				if(currSortMd.selectPlayer.currYW==0){
					isSorting=false;
					showTop(infodata.rowMusicData.length-1);
				}else{
					for (var i:int = 0; i < infodata.rowMusicData.length-2; i++) 
					{
						if(currSortMd.selectPlayer.currYW>infodata.rowMusicData[i].selectPlayer.currYW){
							var movedata:MusicData=infodata.rowMusicData.pop();		
							infodata.rowMusicData.splice(i,0,movedata);
							showTop(i);
						}
					}
					showTop(infodata.rowMusicData.length-1);
				}
			}
		}
		
		private function showTop(No:uint):void{
			
		}
	}
}