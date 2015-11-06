package
{
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	
	import douyu.database.DataBase;
	import douyu.video.Stagevideo;
	import douyu.view.MainView;
	import douyu.vo.InfoData;
	
	import starling.core.Starling;
	
	[SWF(width="1470", height="827",backgroundColor="0x000000")]
	public class LivePlatform extends Sprite
	{
		private var infoData:InfoData;
		private var sv:Stagevideo;
		private var db:DataBase;
		private var mStarling:Starling;
		
		public function LivePlatform()
		{
			infoData=InfoData.instant;
			infoData.getAUTOMvlist();
			initData();
		}
		
		private function initData():void
		{
			db=	DataBase.instant;
			db.addEventListener(DataBase.LINK_DATABASE_COMPLETE,databaseComplete);
			db.openDatabase();
		}
		protected function databaseComplete(event:Event):void
		{
			db.removeEventListener(DataBase.LINK_DATABASE_COMPLETE,databaseComplete);
			//
			Starling.handleLostContext = true;
			
			mStarling = new Starling(MainView, stage, null, null, "auto", Context3DProfile.BASELINE);
			mStarling.enableErrorChecking = isDebugBuild();
			//mStarling.showStats = true;
			//mStarling.showStatsAt("right", "top", 1);
			mStarling.start();
		}
		
		public static function isDebugBuild():Boolean
		{
			return new Error().getStackTrace().search(/:[0-9]+]$/m) > -1;
		}
	}
}