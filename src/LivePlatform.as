package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	
	import douyu.ctrl.CtrlVideo;
	import douyu.ctrl.MainCtrl;
	import douyu.database.DataBase;
	import douyu.video.Stagevideo;
	import douyu.view.MainView;
	import douyu.vo.InfoData;
	
	import starling.core.Starling;
	
	
	[SWF(width="1470", height="827",backgroundColor="0x000000")]
	public class LivePlatform extends Sprite
	{
		private var mStarling:Starling;
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
			//----------------------------------------------------------starling
			Starling.handleLostContext = true;
			mStarling = new Starling(MainView, stage, null, null, "auto", Context3DProfile.BASELINE);
			mStarling.enableErrorChecking = isDebugBuild();
			//mStarling.showStats = true;
			//mStarling.showStatsAt("right", "top", 1);
			mStarling.start();
			//---------------------------------------------------------video
			var stagevideo:Stagevideo=Stagevideo.instant;
			this.addChild(stagevideo);
			//---------------------------------------------------------main ctrl
			var mainCtrl:MainCtrl=MainCtrl.instant;
			mainCtrl.LiveInit();
		}
		
//		private function initData():void
//		{
//			db=	DataBase.instant;
//			db.addEventListener(DataBase.LINK_DATABASE_COMPLETE,databaseComplete);
//			db.openDatabase();
//		}
//		protected function databaseComplete(event:Event):void
//		{
//			db.removeEventListener(DataBase.LINK_DATABASE_COMPLETE,databaseComplete);
//			//
//			var stagaVideo:Stagevideo=Stagevideo.instant;
//			var ctrlvideo:CtrlVideo=CtrlVideo.instant;
//			this.addChild(stagaVideo);
//			//
//			Starling.handleLostContext = true;
//			mStarling = new Starling(MainView, stage, null, null, "auto", Context3DProfile.BASELINE);
//			mStarling.enableErrorChecking = isDebugBuild();
//			//mStarling.showStats = true;
//			//mStarling.showStatsAt("right", "top", 1);
//			mStarling.start();
//		}
		
		public static function isDebugBuild():Boolean
		{
			return new Error().getStackTrace().search(/:[0-9]+]$/m) > -1;
		}
	}
}