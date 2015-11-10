package douyu.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import douyu.view.top.THTop;
	import douyu.data.InfoData;
	
	public class MainView extends Sprite
	{
		private var infodata:InfoData=InfoData.instant;
		private var thtop:THTop=THTop.instant;
		
		public function MainView()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,addStageHandle);
		}
		
		protected function addStageHandle(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,addStageHandle);
			//
			addTHTop();
		}		
		
		//添加土豪榜
		private function addTHTop():void{
			this.addChild(thtop);
			thtop.initView();
			thtop.x=infodata.sgWidth-thtop.width-4;
			thtop.y=4;
		}
		
		
		private static var _instant:MainView;
		
		public static function get instant():MainView
		{
			if( null == _instant )
			{
				_instant = new MainView();
			}
			return _instant;
		}
	}
}