package douyu.view.mp3
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import douyu.data.InfoData;
	import douyu.tool.Tools;
	
	public class MP3background extends Sprite
	{
		private var info:InfoData=InfoData.instant;
		private var loader:Loader=new Loader();
		private var bitmap1:Bitmap;
		private var bitmap2:Bitmap;
		private var changeTime:Timer;
		private var changeFlag:Boolean=true;
		private var newImageRect:Rectangle=new Rectangle();

		private var tw:int;
		private var th:int;
		
		public function MP3background()
		{
			super();
			bgInit();
		}
		
		
		public function playBackground():void{
			changeTime.start();
		}
		
		public function stopBackground():void{
			changeTime.stop();
		}
		
		
		private function bgInit():void{
			tw=info.sgWidth;
			th=info.sgHeight;
			bitmap1=new Bitmap();
			this.addChild(bitmap1);
			bitmap2=new Bitmap();
			this.addChild(bitmap2);
			
			var directory:File = new File();
			var urlStr:String = "file:///"+InfoData.MP3BackGroundImage;
			directory.url = urlStr;
//			directory.getDirectoryListing();
			info.mp3backimageArray=directory.getDirectoryListing();
//			
			for (var i:uint = 0; i < info.mp3backimageArray.length; i++)
			{
				var filetype:String=info.mp3backimageArray[i].type;
				if(filetype!=".jpg" && filetype!=".png"){
					info.mp3backimageArray.splice(i,1);
				}
			}
			
//			info.mp3backimageArray=Tools.getRandomArr(info.mp3backimageArray);
			//
			changeTime=new Timer(10000);
			changeTime.addEventListener(TimerEvent.TIMER,changeTimer);
			
		}
		
		protected function changeTimer(event:TimerEvent):void
		{
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			var url:String=info.mp3backimageArray[Tools.getRandom(0,info.mp3backimageArray.length-1)].url;
			loader.load(new URLRequest(url));		
		}
		
		protected function completeHandler(e:Event):void
		{
			var currImagedata:BitmapData=(e.currentTarget.content as Bitmap).bitmapData;
			if(currImagedata.width>tw){
				var t:Number=tw/currImagedata.width;
				newImageRect.width=int(currImagedata.width*t);
				newImageRect.height=int(currImagedata.height*t);
			}else{
				newImageRect.width=currImagedata.width;
				newImageRect.height=currImagedata.height;
			}
			
			newImageRect.x=tw-newImageRect.width>>1;
			newImageRect.y=th-newImageRect.height>>1;
			//chang fun
			changeImage(currImagedata,newImageRect);
		}
		
		
		
		
		
		private function changeImage(imagedata:BitmapData,imagerect:Rectangle):void{
			if(changeFlag){
				bitmap1.bitmapData = imagedata;	
				bitmap1.width=imagerect.width;
				bitmap1.height=imagerect.height;
				bitmap1.x=imagerect.x;
				bitmap1.y=imagerect.y;
				TweenLite.to(bitmap1,1,{alpha:1});
				TweenLite.to(bitmap2,1,{alpha:0});
			}else{
				bitmap2.bitmapData = imagedata;
				bitmap2.width=imagerect.width;
				bitmap2.height=imagerect.height;
				bitmap2.x=imagerect.x;
				bitmap2.y=imagerect.y;
				TweenLite.to(bitmap2,1,{alpha:1});
				TweenLite.to(bitmap1,1,{alpha:0});
			}
			
			
			
			changeFlag=!changeFlag;
		}
		
		
		private static var _instant:MP3background;
		
		public static function get instant():MP3background
		{
			if( null == _instant )
			{
				_instant = new MP3background();
			}
			return _instant;
		}
	}
}