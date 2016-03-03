/**
 * 自动播放列表
 */
package douyu.command
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.data.InfoData;
	import douyu.data.vo.MusicData;
	
	public class PlayAutoListCommand extends EventDispatcher
	{
		private var ifdt:InfoData=InfoData.instant;
		
		private var playNum:int=0;
		
		public function PlayAutoListCommand(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		
		public function playAutoList():MusicData{
			
			var md:MusicData=new MusicData();
			md.ismv=true;
			md.mvid=ifdt.autoPlayMvNums[playNum];
			
			playNum++;
			if(playNum>=ifdt.autoPlayMvNums.length){
				playNum=0	
			}
			
			return md;
		}
		
		
		private static var _instant:PlayAutoListCommand;
		
		public static function get instant():PlayAutoListCommand
		{
			if( null == _instant )
			{
				_instant = new PlayAutoListCommand();
			}
			return _instant;
		}
	}
}