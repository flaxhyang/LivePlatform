package douyu.ctrl
{
	import douyu.data.InfoData;
	import douyu.data.vo.MusicData;

	public class SelectMusicTopCtrl
	{
		private var infodata:InfoData=InfoData.instant;
		
		private const showMaxNo:uint=10;
		
		private var CurrNo:uint;
		private var sortPlayerId:Vector.<int>=new Vector.<int>();
		private var isSorting:Boolean=false;
		
		private var currSortMd:MusicData;
		
		public function SelectMusicTopCtrl()
		{
		}
		
		public function Sort(SortNo:int=-1):void{
			
			CurrNo=SortNo<0?infodata.rowMusicData.length-1:SortNo;
			sortPlayerId.push(infodata.rowMusicData[CurrNo].selectPlayer.id);
			
			sorting();
		}
		
		private function sorting():void{
			if(isSorting || sortPlayerId.length==0){
				return;
			}
			
			isSorting=true;
			
			if(infodata.rowMusicData.length==1){
				showTop(0);
				return;
			}
			
			var pid:int=sortPlayerId.shift();
			
			for (var j:int = 0; j < infodata.rowMusicData.length; j++) 
			{
				if(pid==infodata.rowMusicData[j].selectPlayer.id){
					CurrNo=j;
					currSortMd=infodata.rowMusicData.splice(CurrNo,1)[0];
					break;
				}
			}
			
			if(currSortMd.selectPlayer.currYW==0){
				infodata.rowMusicData.push(currSortMd);
				showTop(infodata.rowMusicData.length-1);
			}else if(currSortMd.selectPlayer.currYW<=infodata.rowMusicData[infodata.rowMusicData.length].selectPlayer.currYW){
				infodata.rowMusicData.push(currSortMd);
				showTop(infodata.rowMusicData.length-1);
			}else{
				for (var i:int = 0; i < infodata.rowMusicData.length; i++) 
				{
					if(currSortMd.selectPlayer.currYW>infodata.rowMusicData[i].selectPlayer.currYW){
						infodata.rowMusicData.splice(i,0,currSortMd);
						showTop(i);
						break;
					}
				}	
			}
		}
		
		
		private function showTop(No:uint):void{
			if(No>10){
				isSorting=false;
				sorting();
				return
			}
		}
		
		
		
		private static var _instant:SelectMusicTopCtrl;
		
		public static function get instant():SelectMusicTopCtrl
		{
			if( null == _instant )
			{
				_instant = new SelectMusicTopCtrl();
			}
			return _instant;
		}
	}
}