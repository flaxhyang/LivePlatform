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
		private var sortPlayerId:Vector.<OPerationTiao>=new Vector.<OPerationTiao>();
		private var currSortMd:MusicData;
		private var isSorting:Boolean=false;
		
		public function SelectMusicTopCtrl(){
		}
		
		/**
		 * 删除点播条 
		 */		
		public function delectMusic(id:int):void{
			trace("delectMusic")
			sortPlayerId.push(new OPerationTiao(id,2));
			sorting();
		}
		
		/**
		 * 控制点歌排行
		 * @param SortNo：1：新加点播歌曲 ； 
		 *                2：送鱼丸的人，在点歌排行里；
		 */		
		public function Sort(SortNo:int=-1,type:int=1):void{
			trace("SortNo")
			CurrNo=SortNo<0?infodata.rowMusicData.length-1:SortNo;
			sortPlayerId.push(new OPerationTiao(infodata.rowMusicData[CurrNo].selectPlayer.id,type));
			
			sorting();
		}
		
		
	
		
		private function sorting():void{
			
			trace(isSorting,sortPlayerId.length)
			
			if(isSorting || sortPlayerId.length==0){
				return;
			}
			
			isSorting=true;
			
			var pid:OPerationTiao=sortPlayerId.shift();
		
			if(pid.otType==2){
				smt.addEventListener(SelectMusicTop.MOVE_COMPLETE,moveCompleteHandle);
				smt.deletTiao(pid.otId);
				
//				if(infodata.rowMusicData.length>=InfoData.selectMusicTopMax){
//					showTop(infodata.rowMusicData[InfoData.selectMusicTopMax].selectPlayer.id,InfoData.selectMusicTopMax);
//				}else{
//					isSorting=false;
//					sorting();
//				}
				
				
			}else if(pid.otType==1){
			
				//第一个点歌的
				if(infodata.rowMusicData.length==1){
					trace("1")
					showTop(pid.otId,0);
					return;
				}
				
				
				for (var j:int = 0; j < infodata.rowMusicData.length; j++) 
				{
					if(pid.otId==infodata.rowMusicData[j].selectPlayer.id){
						CurrNo=j;
						currSortMd=infodata.rowMusicData.splice(CurrNo,1)[0];
						break;
					}
				}
				if(currSortMd==null)return;
				if(currSortMd.selectPlayer.currYW<=infodata.rowMusicData[infodata.rowMusicData.length-1].selectPlayer.currYW){
					infodata.rowMusicData.push(currSortMd);
	//				trace("2")
					showTop(currSortMd.selectPlayer.id,infodata.rowMusicData.length-1);
				}else{
					for (var i:int = 0; i < infodata.rowMusicData.length; i++) 
					{
						if(currSortMd.selectPlayer.currYW>infodata.rowMusicData[i].selectPlayer.currYW){
							infodata.rowMusicData.splice(i,0,currSortMd);
	//						trace("3")
							showTop(currSortMd.selectPlayer.id,i);
							break;
						}
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
