package douyu.ctrl
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.database.DataBase;
	import douyu.view.top.THTop;
	import douyu.data.InfoData;
	
	public class THTopCtrl extends EventDispatcher
	{
		private var thtop:THTop=THTop.instant;
		private var db:DataBase=DataBase.instant;
		private var infodata:InfoData=InfoData.instant;
		
		public function THTopCtrl(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function getTHData():void{
			db.getTHTopData(10);
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