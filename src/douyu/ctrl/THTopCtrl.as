package douyu.ctrl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.data.InfoData;
	import douyu.database.DataBase;
	import douyu.view.top.THTop;
	
	public class THTopCtrl extends EventDispatcher
	{
		
		private const TopNum:uint=10;
		
		
		private var thtop:THTop=THTop.instant;
		private var db:DataBase=DataBase.instant;
		private var infodata:InfoData=InfoData.instant;
		
		public function THTopCtrl(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function getTHData():void{
			infodata.addEventListener(InfoData.THTOP_DATA_CHANGE,THTopChangeHandle);
			db.getTHTopData(TopNum);
		}
	
		private function THTopChangeHandle(event:Event):void
		{
			infodata.removeEventListener(InfoData.THTOP_DATA_CHANGE,THTopChangeHandle);
			thtop.setData(infodata.THDatas);
		}
		
		/**
		 * 判断是否在土豪榜里
		 * @param id
		 * @return 
		 */		
		public function isTH(id:int):int{
			var thNum:int=-1;
			for (var i:int = 0; i < infodata.THDatas.length; i++) 
			{
				if(infodata.THDatas[i].id==id){
					return i;
				}
			}
			return thNum; 
		}
		
		private static var _instant:THTopCtrl;
		
		public static function get instant():THTopCtrl
		{
			if( null == _instant )
			{
				_instant = new THTopCtrl();
			}
			return _instant;
		}
	}
}