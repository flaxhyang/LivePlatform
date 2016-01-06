package douyu.view.mp3
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import douyu.data.vo.MusicData;
	
	public class GetXiaMiMP3 extends EventDispatcher
	{
		public static const NotFind_MP3:String="notFind_mp3";
		public static const FINd_OK:String="findMp3_ok";
		
		private const seatchXiami:String="http://www.xiami.com/web/search-songs";
		
		private var urlloader:URLLoader;
		private var param:URLVariables;
		private var req:URLRequest;
		
		public var selestMusic:MusicData;
		
		public function GetXiaMiMP3(target:IEventDispatcher=null)
		{
			super(target);
			init();
		}
		
		private function init():void{
			urlloader=new URLLoader();
			urlloader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
			urlloader.addEventListener(Event.COMPLETE, dataReceivedHandler);
			//
			param=new URLVariables();
			param["spm"]="0.0.0.0.cCPFfJ";
			req = new URLRequest(seatchXiami);
			req.method = "GET";
			req.data=param;
		}
		
		public function getMp3(name:String,artist:String):void{
			param["key"]=name+" "+ artist;
			urlloader.load(req);
		}
		
		protected function dataReceivedHandler(event:Event):void
		{
			try{
				var jsonObject:Object = JSON.parse(urlloader.data);
				if(jsonObject!=null){
					selestMusic.mp3Url=jsonObject[0].src;
					selestMusic.playerName=jsonObject[0].author;
					selestMusic.mName=jsonObject[0].title;
					selestMusic.mp3img=jsonObject[0].cover;
					find_ok();
				}else{
					not_find();
				}
			}catch(e:Error){
				not_find();
			}
			
		}
		
		protected function errorHandler(event:IOErrorEvent):void
		{
			not_find();
		}
		
		private function not_find():void{
			this.dispatchEvent(new Event(NotFind_MP3));
		}
		
		private function find_ok():void{
			this.dispatchEvent(new Event(FINd_OK));
		}
		
		private static var _instant:GetXiaMiMP3;
		
		public static function get instant():GetXiaMiMP3
		{
			if( null == _instant )
			{
				_instant = new GetXiaMiMP3();
			}
			return _instant;
		}
	}
}