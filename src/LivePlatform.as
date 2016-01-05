package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import douyu.ctrl.MainCtrl;
	import douyu.video.Stagevideo;
	import douyu.view.MainView;
	import douyu.data.InfoData;
	
//	[SWF(width="1470", height="827",backgroundColor="0x000000")]
	[SWF(width="470", height="227",backgroundColor="0x000000")]
	public class LivePlatform extends Sprite
	{
		private var infodata:InfoData=InfoData.instant;
		private var stageVideo:Stagevideo;

		public function LivePlatform()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init():void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//
			infodata.sgWidth=this.stage.stageWidth;
			infodata.sgHeight=this.stage.stageHeight;
			//---------------------------------------------------------video
			var stagevideo:Stagevideo=Stagevideo.instant;
			this.addChild(stagevideo);
			//----------------------------------------------------------main view
			var mainview:MainView=MainView.instant;
			this.addChild(mainview);
			//---------------------------------------------------------main ctrl
			var mainCtrl:MainCtrl=MainCtrl.instant;
			mainCtrl.LiveInit();
			
		}
		

	}
}