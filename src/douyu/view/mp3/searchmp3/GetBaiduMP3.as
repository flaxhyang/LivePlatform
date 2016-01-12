package douyu.view.mp3.searchmp3
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
	
	public class GetBaiduMP3 extends EventDispatcher
	{
		public static const NotFind_MP3:String="notFind_mp3";
		public static const FINd_OK:String="findMp3_ok";
		//baidu
		private  const searchUrl:String="http://tingapi.ting.baidu.com/v1/restserver/ting";
		
		private var urlloader:URLLoader;
		private var loaderStep:int=0;
		private var tempMusicName:String;
		private var tempArtist:String;
		private var param1:URLVariables;
		private var param2:URLVariables;
		private var req1:URLRequest;
		private var req2:URLRequest;
		
		
		private var loadStep:uint=0;
		private var musicId:String;
		
		
		public var selestMusic:MusicData;
		
		
		public function GetBaiduMP3(target:IEventDispatcher=null)
		{
			super(target);
			init();
		}
		
		private function init():void{
			urlloader=new URLLoader();
			urlloader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
			urlloader.addEventListener(Event.COMPLETE, dataReceivedHandler);
			
			param1=new URLVariables();
			param1["from"]="webapp_music";
			//			param["method"]="baidu.ting.search.catalogSug";
			param1["method"]="baidu.ting.search.common";
			param1["type"]="1";
			param1["format"]="json";
			
			req1 = new URLRequest(searchUrl);
			req1.method = "GET";
			req1.data=param1;
			
			param2=new URLVariables();
			param2["method"]="baidu.ting.song.downWeb";
			param2["format"]="json";
		
			param2["bit"]=128;
			param2["_t"]=new Date().time/1000;
			req2 = new URLRequest(searchUrl);
			req2.method = "GET";
			req2.data=param2;
			
			
		}
		
		public function getMp3(name:String,artist:String):void{
			loadStep=1;
			tempMusicName=name;
			tempArtist=artist;
			param1["query"]=tempMusicName+" "+ tempArtist;
			//
			urlloader.load(req1);
		}
		
		protected function dataReceivedHandler(event:Event):void
		{
			try{
				var jsonObject:Object = JSON.parse(urlloader.data);
				switch(loadStep)
				{
					case 1:
					{
						if(jsonObject.pages.rn_num>0){
							musicId=jsonObject.song_list[0].song_id;
							tempArtist=jsonObject.song_list[0].author;
							param2["songid"]=musicId;
							loadStep=2;
							urlloader.load(req2);
						}else{
							not_find();
						}
						break;
					}
						
					case 2:
					{
						selestMusic.mp3Url=jsonObject.bitrate[0].file_link;
						selestMusic.lrclink=jsonObject.songinfo.lrclink;
						selestMusic.mName=jsonObject.songinfo.title;
						selestMusic.playerName=jsonObject.songinfo.author;
						selestMusic.mp3img=jsonObject.songinfo.pic_small;
						selestMusic.musicTime=int(jsonObject.bitrate[0].file_duration);
						find_ok();
						break;
					}
					default:
					{
						break;
					}
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
		
		
		private static var _instant:GetBaiduMP3;
		
		public static function get instant():GetBaiduMP3
		{
			if( null == _instant )
			{
				_instant = new GetBaiduMP3();
			}
			return _instant;
		}
		
	}
}