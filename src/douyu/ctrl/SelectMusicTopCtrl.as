package douyu.ctrl
{
	import flash.events.Event;
	
	import douyu.data.InfoData;
	import douyu.data.vo.MusicData;
	import douyu.view.showlayer.SelectMusicTop;

	public class SelectMusicTopCtrl
	{
		private var infodata:InfoData=InfoData.instant;
		private var smt:SelectMusicTop=SelectMusicTop.instant;
		
		private var CurrNo:uint;
		private var sortPlayerId:Vector.<int>=new Vector.<int>();
		private var isSorting:Boolean=false;
		
		private var currSortMd:MusicData;
		
		public function SelectMusicTopCtrl()
		{
		}
		
		public function delectMusic():void{
			smt.deletTiao();
			if(infodata.rowMusicData.length>=InfoData.selectMusicTopMax){
				showTop(infodata.rowMusicData[InfoData.selectMusicTopMax].selectPlayer.id,InfoData.selectMusicTopMax);
			}
		}
		
		/**
		 * 控制点歌排行
		 * @param SortNo：1：新加点播歌曲 ； 
		 *                2：送鱼丸的人，在点歌排行里；
		 */		
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
			
			var pid:int=sortPlayerId.shift();
			
			//第一个点歌的
			if(infodata.rowMusicData.length==1){
				trace("1")
				showTop(pid,0);
				return;
			}
			
			
			for (var j:int = 0; j < infodata.rowMusicData.length; j++) 
			{
				if(pid==infodata.rowMusicData[j].selectPlayer.id){
					CurrNo=j;
					currSortMd=infodata.rowMusicData.splice(CurrNo,1)[0];
					break;
				}
			}
			
			if(currSortMd.selectPlayer.currYW<=infodata.rowMusicData[infodata.rowMusicData.length-1].selectPlayer.currYW){
				infodata.rowMusicData.push(currSortMd);
				trace("2")
				showTop(currSortMd.selectPlayer.id,infodata.rowMusicData.length-1);
			}else{
				for (var i:int = 0; i < infodata.rowMusicData.length; i++) 
				{
					if(currSortMd.selectPlayer.currYW>infodata.rowMusicData[i].selectPlayer.currYW){
						infodata.rowMusicData.splice(i,0,currSortMd);
						trace("3")
						showTop(currSortMd.selectPlayer.id,i);
						break;
					}
				}	
			}
		}
		
		
		private function showTop(playerId:int,No:uint):void{
//			trace(playerId,No);
			if(No>InfoData.selectMusicTopMax){
				isSorting=false;
				sorting();
			}else{
				smt.addEventListener(SelectMusicTop.MOVE_COMPLETE,moveCompleteHandle);
				smt.showTiao(playerId,No);
			}
			
		}
		
		protected function moveCompleteHandle(event:Event):void
		{
			smt.removeEventListener(SelectMusicTop.MOVE_COMPLETE,moveCompleteHandle);
			isSorting=false;
			sorting();
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