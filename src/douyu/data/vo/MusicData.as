package douyu.data.vo
{
	public class MusicData
	{
		public function MusicData()
		{
		}
		
		public var ismv:Boolean=false;
		
		public var mvid:int;
		
		public var mName:String;
		//music 演唱者
		public var playerName:String;
		
		public var mp3Url:String;
		public var mp3img:String;
		public var lrclink:String;
		
		
		public var musicTime:int=0;
		
		public var selectPlayer:PlayerData=null;
		
		//是否为 自动歌单播放
		public var listSelectPlayer:Boolean=false;
	}
}