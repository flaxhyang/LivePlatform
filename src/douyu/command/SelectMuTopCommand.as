/**
 * 点歌榜单逻辑 
 */
package douyu.command
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.ctrl.SelectMusicTopCtrl;
	import douyu.ctrl.THTopCtrl;
	import douyu.data.InfoData;
	import douyu.data.vo.PlayerData;
	import douyu.database.DataBase;
	
	public class SelectMuTopCommand extends EventDispatcher
	{
		//扣鱼丸时候 没有足够的鱼丸
		public static const CURRYW_WITHOUT:String="currYw_without";
		//扣鱼丸 成功
		public static const CURRYW_COMPLETE:String="currYw_complete";
		
		
		private var db:DataBase=DataBase.instant;
		private var infodata:InfoData=InfoData.instant;
		private var smtc:SelectMusicTopCtrl=SelectMusicTopCtrl.instant;
		private var thtc:THTopCtrl=THTopCtrl.instant;
		
		private var isOperaing:Boolean=false;
		private var operateArr:Vector.<PlayerData>=new Vector.<PlayerData>();
		
		//当前 操作的 OperatePlayer
		private var _currOP:PlayerData;
		private var currOPTopNum:int;
		
		public function SelectMuTopCommand(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function addNewOP(player:PlayerData,type:int):void{
			var opPlaer:PlayerData=new PlayerData();
			opPlaer.id=player.id;
			opPlaer.currYW=player.currYW;
//			opPlaer.totleYW=player.currYW;
			opPlaer.nick=player.nick;
			opPlaer.notice=player.notice;
			opPlaer.THMessage=player.THMessage;
			opPlaer.OperationType=type;
			opPlaer.OperationCutYW=player.OperationCutYW;
			opPlaer.OPerationAddYW=player.OPerationAddYW;
			operateArr.push(opPlaer);
			operation();
		}
		
		private function operation():void{
			if(isOperaing || operateArr.length==0){
				return;
			}
			
			isOperaing=true;
			
			_currOP=operateArr.shift();
			
			db.addEventListener(DataBase.SEARCH_YWTOP_COMPLETE,searchComplete);
			db.addEventListener(DataBase.SEARCH_YWTOP_FAIL,searchFail);
			db.SearchPlayer(_currOP);
			
		}
		
		protected function searchFail(event:Event):void
		{
			switch(_currOP.OperationType)
			{
				case 1://点歌的人
				{
					changeSelectTop();
					isOperaing=false;
					operation();
					break;
				}
				case 2://送礼物的人
				{
					insertYWTop();
					break;
				}
				case 3://扣礼物的人
				{
					this.dispatchEvent(new Event(CURRYW_WITHOUT));
					isOperaing=false;
					operation();
					break;
				}
				case 4:{
					isOperaing=false;
					operation();
					break;
				}	
				default:
				{
					break;
				}
			}			
			
		}
		
		protected function searchComplete(event:Event):void
		{
			switch(_currOP.OperationType)
			{
				case 1://点歌的人
				{
					changeSelectTop();
					isOperaing=false;
					operation();
					break;
				}
				case 2://送礼物的人
				{
					changeSelectTop();
					changeYWTop();
					break;
				}
				case 3://扣鱼丸的人	
				{
					if(db.currPd.currYW<0){
						this.dispatchEvent(new Event(CURRYW_WITHOUT));
						isOperaing=false;
						operation();
					}else{
						changeSelectTop();
						changeYWTop();
						this.dispatchEvent(new Event(CURRYW_COMPLETE));
					}
					break;
				}
				case 4://修改数据
				{
					changeYWTop();
					break;
				}	
				default:
				{
					break;
				}
			}			
		}		
		
		//点歌列表数据修改
		private function changeSelectTop():void{
			currOPTopNum=infodata.getPlayerNum(_currOP.id);
			if(currOPTopNum<0){
				//操作 正在播放的
				if(infodata.playMusicdata.selectPlayer.id==_currOP.id){
					infodata.playMusicdata.selectPlayer.currYW=db.currPd.currYW;
					infodata.changeMusicdata(infodata.playMusicdata);
				}
			}else{
				infodata.rowMusicData[currOPTopNum].selectPlayer.currYW=db.currPd.currYW;
//				infodata.rowMusicData[currOPTopNum].selectPlayer.totleYW=db.currPd.totleYW;
//				trace(infodata.rowMusicData.length);
				
				smtc.Sort(infodata.rowMusicData[currOPTopNum].selectPlayer.id);
			}
		
		}
		
		//送鱼丸的人，加鱼丸的操作
		private function changeYWTop():void{
			db.addEventListener(DataBase.CHANGE_YWTOP_COMPLETE,dataBaseChangeComplete);
			db.changePlayerData(db.currPd);
		}
		
		private function insertYWTop():void{
			db.addEventListener(DataBase.CHANGE_YWTOP_COMPLETE,dataBaseChangeComplete);
			db.insertPlayer(db.currPd);
		}
		
		protected function dataBaseChangeComplete(event:Event):void
		{
			//刷新 鱼丸总榜
			thtc.getTHData();
			//
			isOperaing=false;
			operation();	
		}
		
		private static var _instant:SelectMuTopCommand;
		
		public static function get instant():SelectMuTopCommand
		{
			if( null == _instant )
			{
				_instant = new SelectMuTopCommand();
			}
			return _instant;
		}
	}
}



