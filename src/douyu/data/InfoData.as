package douyu.data
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.data.vo.MusicData;
	import douyu.data.vo.PlayerData;

	public class InfoData extends EventDispatcher
	{
		//work
		public static const DataBaseURL:String="D:/ASWORK/LivePlatform/TempFile/YZYDOUYUData0317.db";
		public static const AuthorityURL:String="D:/ASWORK/LivePlatform/TempFile/Authority.txt";
		public static const MTVListURL:String="D:/ASWORK/LivePlatform/TempFile/mtvlist.txt";
		public static const MTVURL:String="";
		public static const MTVImage:String="";
		public static const MP3BackGroundImage:String="D:/ASWORK/LivePlatform/TempFile/mp3background/";
		
		//home
//		public static const DataBaseURL:String="G:/FBWORK/LivePlatform/TempFile/YZYDOUYUData0317.db";
//		public static const AuthorityURL:String="G:/FBWORK/LivePlatform/TempFile/Authority.txt";
//		public static const MTVListURL:String="G:/FBWORK/LivePlatform/TempFile/mtvlist.txt";
//		public static const MTVURL:String="";
//		public static const MTVImage:String="";
//		public static const MP3BackGroundImage:String="G:/FBWORK/LivePlatform/TempFile/mp3background/";

		//发布
//		public static const DataBaseURL:String="C:/YZYDOUYUData.db";
//		public static const MTVURL:String="d:/mtv/";
//		public static const MTVImage:String="d:/MTVImage/";
//		public static const AuthorityURL:String="C:/Authority.txt";
//		public static const noticeURL:String="C:/Notice.txt";
//		public static const mmURL:String="C:/MM.txt";
//		public static const mmImage:String="d:/mmimage/";
		
		
		public static const fontNames:String = "Microsoft YaHei,微软雅黑,MSYaHei,SimHei,Roboto,Arial,_sans";
		//
		public var sgWidth:int;
		public var sgHeight:int;
		
		//-----------------------------------------------------------------------------data change event
		public static const THTOP_DATA_CHANGE:String="thtop_data_change";
		public static const ROW_MUSIC_CHANGE:String="row_music_change";
		public static const MUSIC_NOT_FIND:String="music_not_find";
		public static const NEW_MUSIC_DATA:String="new_music_data";
		public static const MUSIC_PLAY_COMPLETE:String="music_play_complete";
		
		
		
		//---------------------------------------------------------------------------event 
		/**
		 *  music 播放完成 
		 */
		public function music_stop():void{
			this.dispatchEvent(new Event(MUSIC_PLAY_COMPLETE));
		}
		
		/**
		 *music 搜寻错误（没有找到此歌曲）  
		 */		
        public function musicNotFind():void{
			this.dispatchEvent(new Event(MUSIC_NOT_FIND));
		} 		
		
		//----------------------------------------------------------------------------数据 组
		public var newMusicData:MusicData;
		
		private var _rowMusicData:Vector.<MusicData>=new Vector.<MusicData>();
		/**
		 * 排队播放列表
		 * @return 
		 */         
		public function get rowMusicData():Vector.<MusicData>
		{
			return _rowMusicData;
		}

		public function setRowMusicData(md:MusicData):void
		{
			newMusicData=md;
			this.dispatchEvent(new Event(NEW_MUSIC_DATA));
		}
		
		public function addNewMusicData():void{
			_rowMusicData.push(newMusicData);
			this.dispatchEvent(new Event(ROW_MUSIC_CHANGE)); 
		}
		
		
		
		private var _playMusicdata:MusicData
		/**
		 * 当前播放歌曲data
		 * @return 
		 */
		public function get playMusicdata():MusicData
		{
			return _playMusicdata;
		}

		public function set playMusicdata(value:MusicData):void
		{
			_playMusicdata = value;
		}
		
		
		private var _autoPlayMvNums:Array;
		/**
		 * 自动播放歌单列表
		 * @return 
		 */		
		public function get autoPlayMvNums():Array
		{
			return _autoPlayMvNums;
		}
		
		public function set autoPlayMvNums(value:Array):void
		{
			_autoPlayMvNums = value;
		}
		//------------
		private var _THDatas:Vector.<PlayerData> 
		/**
		 * 土豪榜 列表数据
		 * @return 
		 */
		public function get THDatas():Vector.<PlayerData>
		{
			return _THDatas;
		}

		public function set THDatas(value:Vector.<PlayerData>):void
		{
			_THDatas = value;
			this.dispatchEvent(new Event(THTOP_DATA_CHANGE));
		}
		
		
		private var _mp3backimageArray:Array=new Array()
		/**
         * mp3 背景 图片集 数据 
		 * @return 
		 */		
		public function get mp3backimageArray():Array
		{
			return _mp3backimageArray;
		}

		public function set mp3backimageArray(value:Array):void
		{
			_mp3backimageArray = value;
		}

		
		public function InfoData(target:IEventDispatcher=null)
		{
			super(target);
			
		}
		
		private static var _instant:InfoData;
		
		public static function get instant():InfoData
		{
			if( null == _instant )
			{
				_instant = new InfoData();
			}
			return _instant;
		}
	}
}