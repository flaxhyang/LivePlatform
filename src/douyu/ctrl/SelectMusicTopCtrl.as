package douyu.ctrl
{
	import flash.events.Event;
	import flash.ui.MultitouchInputMode;
	
	import douyu.data.InfoData;
	import douyu.data.vo.MusicData;
	import douyu.view.showlayer.SelectMusicTop;

	public class SelectMusicTopCtrl
	{
		
		private var infodata:InfoData=InfoData.instant;
		private var smt:SelectMusicTop=SelectMusicTop.instant;
		
		
		private var sortPlayerId:Vector.<OPerationTiao>=new Vector.<OPerationTiao>();
		private var currSortMd:MusicData;
		private var isSorting:Boolean=false;
		
		public function SelectMusicTopCtrl(){
		}
		
		/**
		 * 删除点播条 
		 */		
		public function delectMusic(id:int):void{
//			trace("delectMusic")
			sortPlayerId.push(new OPerationTiao(id,2));
			sorting();
		}
		
		/**
		 * 控制点歌排行
		 * @param SortNo：1：新加点播歌曲 ； 
		 *                2：送鱼丸的人，在点歌排行里；
		 */		
		public function Sort(SortId:int=-1,type:int=1):void{
			sortPlayerId.push(new OPerationTiao(SortId,type));
			sorting();
		}
		
		
	
		
		private function sorting():void{
			if(isSorting || sortPlayerId.length==0){
				return;
			}
			isSorting=true;
			
			var pid:OPerationTiao=sortPlayerId.shift();
			if(pid.otType==2){
				smt.addEventListener(SelectMusicTop.MOVE_COMPLETE,moveCompleteHandle);
				smt.deletTiao(pid.otId);
			}else if(pid.otType==1){
				var fromNo:int;
				var toNo:int;
				
				for (var i3:int = 0; i3 < infodata.rowMusicData.length; i3++) 
				{
					if(pid.otId==infodata.rowMusicData[i3].selectPlayer.id){
						fromNo=i3;
						break;
					}
				}
				
				
				//bubble sort
				var tmp:MusicData;	
				for (var i:int = 0; i < infodata.rowMusicData.length; i++) 
				{
					for (var j:int = 0; j < infodata.rowMusicData.length-i-1; j++) 
					{
						if(infodata.rowMusicData[j].selectPlayer.currYW<infodata.rowMusicData[j+1].selectPlayer.currYW){
							tmp=infodata.rowMusicData[j];
							infodata.rowMusicData[j]=infodata.rowMusicData[j+1];
							infodata.rowMusicData[j+1]=tmp;
						}
					}
					
				}
				//quickSort
//				quickSort(0,infodata.rowMusicData.length-1);
				
				for (var k:int = 0; k < infodata.rowMusicData.length; k++) 
				{
					if(pid.otId==infodata.rowMusicData[k].selectPlayer.id){
						toNo=k;
						break;
					}
				}
				
//				for (var i2:int = 0; i2 < infodata.rowMusicData.length; i2++) 
//				{
//					trace(infodata.rowMusicData[i2].selectPlayer.id)
//				}
//				trace("-----------------------------------------")
				
				smt.addEventListener(SelectMusicTop.MOVE_COMPLETE,moveCompleteHandle);
				smt.showTiao(pid.otId,fromNo,toNo);
			}
		}
		
		protected function moveCompleteHandle(event:Event):void
		{
			smt.removeEventListener(SelectMusicTop.MOVE_COMPLETE,moveCompleteHandle);
			isSorting=false;
			sorting();
		}		
		
		
	    //
		private function quickSort(start:int,end:int):void{
			if(start<end){
				var i:int=start;
				var j:int=end;
				while(i<j){
					while(i<j && infodata.rowMusicData[i].selectPlayer.currYW>=infodata.rowMusicData[j].selectPlayer.currYW) j--;
					
					if(i<j){
						swap(i,j)
					}
					
					while(i<j&&infodata.rowMusicData[i].selectPlayer.currYW>infodata.rowMusicData[j].selectPlayer.currYW) i++;
					if(i<j){
						swap(i,j)
					}
					
				}
				if(i-start>1){
					quickSort(start,i-1);
				}
				if(end-i>1){
					quickSort(i+1,end);
				}
					
			}
		}
		
		private function swap(i:int,j:int):void{
		
			var temp:MusicData;
			temp=infodata.rowMusicData[i];
			infodata.rowMusicData[i]=infodata.rowMusicData[j];
			infodata.rowMusicData[j]=temp;
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

class OPerationTiao{
	
	
	public function OPerationTiao(id:int,type:int){
		otId=id;
		otType=type;
	}
	
	private var _otId:int;
	/**
	 * 操作的player id
	 * @return 
	 */
	public function get otId():int
	{
		return _otId;
	}

	public function set otId(value:int):void
	{
		_otId = value;
	}

	private var _otType:int;
	/**
	 * 操作类型： 1：添加  2：删除 
	 * @return 
	 */	
	public function get otType():int
	{
		return _otType;
	}

	public function set otType(value:int):void
	{
		_otType = value;
	}

}
