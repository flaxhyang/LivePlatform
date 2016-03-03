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
		public static const MTVURL:String="D:/ASWORK/LivePlatform/TempFile/mtv/";
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
		
		//点歌榜显示的条数
		public static const selectMusicTopMax:uint=10;
		
		//点歌扣得鱼丸数
		public static const cutYWforSelect:uint=2;
		//其他操作扣得鱼丸数
		public static const cutYWforOther:uint=1;
		//
		public var sgWidth:int;
		public var sgHeight:int;
		
		//-----------------------------------------------------------------------------data change event
		public static const THTOP_DATA_CHANGE:String="thtop_data_change";
		public static const MUSIC_NOT_FIND:String="music_not_find";//没有找到歌曲
		public static const NEW_MUSIC_DATA:String="new_music_data";//点新歌
	    public static const DELET_MUSIC_DATA:String="delet_music_data";//删除点歌帮信息
		public static const MUSIC_PLAY_COMPLETE:String="music_play_complete";//歌曲播放完成
		public static const MUSIC_PLAYING_EVENT:String="music_playing_event";//歌曲开始播放
		public static const PLAY_MUSIC_DATACHANGE:String="play_music_datachange";//修改当前播放的歌的信息
		
		
		
		//---------------------------------------------------------------------------event 
		
//		
		
		
		
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
//		public var newMusicData:MusicData;
		
		private var _rowMusicData:Vector.<MusicData>=new Vector.<MusicData>();
		/**
		 * 排队播放列表
		 * @return 
		 */
		//获取列表
		public function get rowMusicData():Vector.<MusicData>
		{
			return _rowMusicData;
		}
		//添加新值（点歌表）
		public function setRowMusicData(md:MusicData):void
		{
			//
			if(md.selectPlayer!=null){
				//如果是已经点歌的人，要先删除 以前点过的歌tiao
				var newMusicNum:int=getPlayerNum(md.selectPlayer.id);
				if(newMusicNum>=0){
					deleteSTMusicData(newMusicNum);
				}
			}
			_rowMusicData.push(md);
			this.dispatchEvent(new Event(NEW_MUSIC_DATA));
		}
		
		//获取player 位置
		public function getPlayerNum(id:int):int{
			for (var i:int = 0; i < _rowMusicData.length; i++) 
			{
				if(_rowMusicData[i].selectPlayer.id==id){
					return i;
				}
			}
			
			return -1;	
		}
		
		//获取 单值（MusicData）		
		public function getMusicData(num:int):MusicData{
			var md:MusicData=_rowMusicData[num];
			if(md){
				return md;
			}else{
				return null;
			}
		}
		//修改值
		public function changeMusicData(md:MusicData,num:int):void{
			_rowMusicData[num]=md;
		}
		
		//删除点歌榜的值
		public var deletSeleteMusicPid:int;
		public function deleteSTMusicData(num:int):MusicData{
			var tmd:MusicData=_rowMusicData.splice(num,1)[0];
			if(tmd.selectPlayer==null)return tmd;
			deletSeleteMusicPid=tmd.selectPlayer.id;
			this.dispatchEvent(new Event(DELET_MUSIC_DATA));
			return tmd;
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
			this.dispatchEvent(new Event(MUSIC_PLAYING_EVENT));
		}
		public function changeMusicdata(value:MusicData):void{
			_playMusicdata = value;
			this.dispatchEvent(new Event(PLAY_MUSIC_DATACHANGE));
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