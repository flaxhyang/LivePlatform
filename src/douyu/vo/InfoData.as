package douyu.vo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	public class InfoData extends EventDispatcher
	{
		//work
		public static const DataBaseURL:String="D:/Workspace/minGame/LivePlatform/TempFile/YZYDOUYUData0317.db";
		public static const AuthorityURL:String="D:/Workspace/minGame/LivePlatform/TempFile/Authority.txt";
		public static const MTVListURL:String="D:/Workspace/minGame/LivePlatform/TempFile/mtvlist.txt";
		public static const MTVURL:String="";
		public static const MTVImage:String="";
		
		//home
//		private static const DataBaseURL:String="D:/Workspace/minGame/LivePlatform/TempFile/YZYDOUYUData0317.db";
//		private static const AuthorityURL:String="D:/Workspace/minGame/LivePlatform/TempFile/Authority.txt";
//		private static const MTVListURL:String="D:/Workspace/minGame/LivePlatform/TempFile/mtvlist.txt";
//		public static const MTVURL:String="";
//		public static const MTVImage:String="";

		//发布
//		public static const DataBaseURL:String="C:/YZYDOUYUData.db";
//		public static const MTVURL:String="d:/mtv/";
//		public static const MTVImage:String="d:/MTVImage/";
//		public static const AuthorityURL:String="C:/Authority.txt";
//		public static const noticeURL:String="C:/Notice.txt";
//		public static const mmURL:String="C:/MM.txt";
//		public static const mmImage:String="d:/mmimage/";
		
		
		//
		
		//----------------------------------------------------------------------------
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
		//----------------------------------------------------------------------------
		
		
		
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