package douyu.data
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.data.vo.MusicData;
	import douyu.data.vo.PlayerData;
	import douyu.robot.AotuTlak;

	public class InfoData extends EventDispatcher
	{
		//work
		//public static const initVideoURL:String="D:/ASWORK/LivePlatform/TempFile/begin.mp4";
		//public static const initVideoURL:String="http://60.10.3.99/v4.music.126.net/20160325174529/631e2001f9ad02f3093e996ac99c6e06/web/cloudmusic/OCIiOCAxMjQwIDAyIiEhIg==/mv/486094/c16d51f7a0df9b4699d7e5023bbb4769.mp4";
		public static const initVideoURL:String="http://60.10.3.99/20160325174529/631e2001f9ad02f3093e996ac99c6e06/web/cloudmusic/OCIiOCAxMjQwIDAyIiEhIg==/mv/486094/c16d51f7a0df9b4699d7e5023bbb4769.mp4";
		public static const DataBaseURL:String="D:/ASWORK/LivePlatform/TempFile/YZYDOUYUData0317.db";
		public static const AuthorityURL:String="D:/ASWORK/LivePlatform/TempFile/Authority.txt";
		public static const MTVListURL:String="D:/ASWORK/LivePlatform/TempFile/mtvlist.txt";
		public static const MTVURL:String="D:/ASWORK/LivePlatform/TempFile/mtv/";
		public static const MP3BackGroundImage:String="D:/ASWORK/LivePlatform/TempFile/mp3background/";
		public static const AUTOMSGURL:String="D:/ASWORK/LivePlatform/TempFile/word.txt";
		
		//home
//		public static const initVideoURL:String="G:/FBWORK/LivePlatform/TempFile/begin.mp4";
//		public static const DataBaseURL:String="G:/FBWORK/LivePlatform/TempFile/YZYDOUYUData0317.db";
//		public static const AuthorityURL:String="G:/FBWORK/LivePlatform/TempFile/Authority.txt";
//		public static const MTVListURL:String="G:/FBWORK/LivePlatform/TempFile/mtvlist.txt";
//		public static const MTVURL:String="G:/FBWORK/LivePlatform/TempFile/mtv/";
//		public static const MP3BackGroundImage:String="G:/FBWORK/LivePlatform/TempFile/mp3background/";


		//发布
//		public static const initVideoURL:String="c:/begin.mp4";
//		public static const DataBaseURL:String="c:/YZYDOUYUData.db";
//		public static const AuthorityURL:String="c:/Authority.txt";
//		public static const MTVListURL:String="c:/mtvlist.txt";
//		public static const MTVURL:String="d:/mtv/";
//		public static const MP3BackGroundImage:String="c:/mp3background/";
		
		

		
		
		public static const fontNames:String = "Microsoft YaHei,微软雅黑,MSYaHei,SimHei,Roboto,Arial,_sans";
		
		//点歌榜显示的条数
		public static const selectMusicTopMax:uint=3;
		
		//点歌扣得鱼丸数
		public static const CUTYWforSelect:uint=2;
		//其他操作扣得鱼丸数
		public static const cutYWforOther:uint=1;
		//
		public var sgWidth:int;
		public var sgHeight:int;
		
		//-----------------------------------------------------------------------------data change event
		public static const THTOP_DATA_CHANGE:String="thtop_data_change";
		public static const MUSIC_NOT_FIND:String="music_not_find";//没有找到歌曲
		public static const MUSIC_FIND_OK:String="music_find_ok";//搜到要播放的歌曲（费点播时）
		public static const NEW_SELECT_MUSIC_DATA:String="new_select_music_data";//点新歌
		
	    public static const DELET_MUSIC_DATA:String="delet_music_data";//删除点歌帮信息
		public static const MUSIC_PLAY_COMPLETE:String="music_play_complete";//歌曲播放完成
		public static const MUSIC_PLAYING_EVENT:String="music_playing_event";//歌曲开始播放
		public static const PlAY_MUSIC_DATACHANGE:String="play_music_datachange";//当前播放歌曲 信息改变
	
		
		
		
		//---------------------------------------------------------------------------event 
		
//		
		private var at:AotuTlak=AotuTlak.instant;
		
		
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

		// 点歌列表
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
			if(md.selectPlayer!=null && md.listSelectPlayer==false){
				//如果是已经点歌的人，要先删除 以前点过的歌tiao
				var newMusicNum:int=getPlayerNum(md.selectPlayer.id);
				if(newMusicNum>=0){
					deleteSTMusicData(newMusicNum);
				}
				_rowMusicData.push(md);
				at.sendMsg(md.mName+" 点播成功！");
				this.dispatchEvent(new Event(NEW_SELECT_MUSIC_DATA));
			}else {
				_playMusicdata=md;
				this.dispatchEvent(new Event(MUSIC_FIND_OK));
			}
			
			
		}
		
		//获取player 位置
		public function getPlayerNum(id:int):int{
			for (var i:int = 0; i < _rowMusicData.length; i++) 
			{
				if(_rowMusicData[i].selectPlayer!==null){
					if(_rowMusicData[i].selectPlayer.id==id){
						return i;
					}
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
//			trace("delete  _rowMusicData")
			var tmd:MusicData=_rowMusicData.splice(num,1)[0];
			if(tmd.selectPlayer==null)return tmd;
			deletSeleteMusicPid=tmd.selectPlayer.id;
			this.dispatchEvent(new Event(DELET_MUSIC_DATA));
			return tmd;
		}
		
		//土豪 默认列表
		private var _thRowMusicData:Vector.<MusicData>=new Vector.<MusicData>();

		public function get thRowMusicData():Vector.<MusicData>
		{
			return _thRowMusicData;
		}

		public function setThRowMusicData(value:MusicData):void
		{
			_thRowMusicData.push(value);
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
		
		/**
		 * 查询鱼丸回来的数据，当前music已经在播放中  & 播放中 修改喇叭
		 * @param value
		 */		
		public function changeMusicdata(value:MusicData):void{
			_playMusicdata = value;
			this.dispatchEvent(new Event(PlAY_MUSIC_DATACHANGE));
		}
		
		//------------
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