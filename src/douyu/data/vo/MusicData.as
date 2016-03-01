package douyu.data.vo
{
	public class MusicData
	{
		public function MusicData()
		{
		}
		//是否是 mv
		public var ismv:Boolean=true;
		
		//是否为 自动歌单播放
		public var listSelectPlayer:Boolean=false;
		
		
		//mv
		public var mvid:int;
		
		//mp3
		public var mp3img:String;
		public var lrclink:String;
		
		
		public var musicUrl:String;// music  url
		public var musicTime:int=0;//歌曲 时常
		public var mName:String;//歌名
		public var playerName:String;//演唱者
		public var selectPlayer:PlayerData=null;
		
	}
}