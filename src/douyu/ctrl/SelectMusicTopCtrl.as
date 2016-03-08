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
		
		private var CurrNo:uint;
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
				pid.otId;
//				CurrNo=-1;
//				var rmdl:int=infodata.rowMusicData.length;
//				for (var j:int = 0; j < rmdl; j++) 
//				{
//					if(pid.otId==infodata.rowMusicData[j].selectPlayer.id){
//						CurrNo=j;
//						currSortMd=infodata.rowMusicData.splice(CurrNo,1)[0];
//						break;
//					}
//				}
//				if(currSortMd==null || CurrNo<0)return;
				
//				rmdl=infodata.rowMusicData.length-1;
//				if(CurrNo==0 || CurrNo>=rmdl){
//				}else if(currSortMd.selectPlayer.currYW>=infodata.rowMusicData[CurrNo-1].selectPlayer.currYW && currSortMd.selectPlayer.currYW<=infodata.rowMusicData[CurrNo].selectPlayer.currYW){
//				}else{
//					CurrNo=-1;
//					for (var i:int = rmdl; i >=0 ; i--) 
//					{
//						if(currSortMd.selectPlayer.currYW<=infodata.rowMusicData[i].selectPlayer.currYW){
//							CurrNo=i+1;
//							break;
//						}
//					}
//					
//					CurrNo=CurrNo<0?0:CurrNo;
//					
//				}
//				infodata.rowMusicData.splice(CurrNo,0,currSortMd);
				
//				isSorting=false;
//				sorting();
				
				var tmp:MusicData;	
				for (var i:int = 0; i < infodata.rowMusicData.length; i++) 
				{
					for (var j:int = i; j < infodata.rowMusicData.length; j++) 
					{
						if(infodata.rowMusicData[i].selectPlayer.currYW<infodata.rowMusicData[j].selectPlayer.currYW){
							tmp=infodata.rowMusicData[i];
							infodata.rowMusicData[i]=infodata.rowMusicData[j];
							infodata.rowMusicData[j]=tmp;
						}
					}
					
				}
				
				for (var k:int = 0; k < infodata.rowMusicData.length; k++) 
				{
					if(pid.otId==infodata.rowMusicData[k].selectPlayer.id){
						CurrNo=k;
						break;
					}
				}
				
				
				
				showTop(pid.otId,CurrNo);
			}
		}
		
		
		private function showTop(playerId:int,No:uint):void{
//			if(No>=InfoData.selectMusicTopMax){
//				isSorting=false;
//				sorting();
//			}else{
				smt.addEventListener(SelectMusicTop.MOVE_COMPLETE,moveCompleteHandle);
				smt.showTiao(playerId,No);
//			}
			
			
			
		
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
