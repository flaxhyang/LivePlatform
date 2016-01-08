package douyu.command.nextMusic
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	public class selectMusicCommand extends EventDispatcher
	{
		public function selectMusicCommand(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		
		private static var _instant:selectMusicCommand;
		
		public static function get instant():selectMusicCommand
		{
			if( null == _instant )
			{
				_instant = new selectMusicCommand();
			}
			return _instant;
		}
	}
}