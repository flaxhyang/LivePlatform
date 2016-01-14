package douyu.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import douyu.data.InfoData;
	import douyu.view.mp3.MP3Play;
	import douyu.view.top.THTop;
	import douyu.view.video.Stagevideo;
	
	public class MainView extends Sprite
	{
		private var infodata:InfoData=InfoData.instant;
		private var stagevideo:Stagevideo=Stagevideo.instant;
		private var thtop:THTop=THTop.instant;
		private var mp3:MP3Play=MP3Play.instant;
		
		public function MainView()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,addStageHandle);
		}
		
		protected function addStageHandle(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,addStageHandle);
			//
			addMv();
			//
			addMP3();
			//
			addTHTop();
		}	
		//添加 mv 面板
		private function addMv():void{
			
			this.addChild(stagevideo);
		}
		
		//添加mp3播放面板
		private function addMP3():void{
			this.addChild(mp3);
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