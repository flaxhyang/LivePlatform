package douyu.ctrl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.command.GiftCommand;
	import douyu.data.InfoData;
	import douyu.data.vo.PlayerData;
	import douyu.view.showlayer.MusicInfo;
	
	public class CurrPlayerMusicCtrl extends EventDispatcher
	{
		private var mi:MusicInfo=MusicInfo.instant;
		private var infodata:InfoData=InfoData.instant;
		private var gc:GiftCommand=GiftCommand.instant;
		
		public function CurrPlayerMusicCtrl(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function init():void{
			infodata.addEventListener(InfoData.MUSIC_PLAYING_EVENT,playingMusicHnadle);
			infodata.addEventListener(InfoData.PLAY_MUSIC_DATACHANGE,changedatahandle);
		}
		
		protected function changedatahandle(event:Event):void
		{
			mi.setYWTiao(infodata.playMusicdata.selectPlayer.currYW);
		}
		
		protected function playingMusicHnadle(event:Event):void
		{
			//开始播放点播歌曲时 修改点播人鱼丸
			gc.cutYWForSelect(infodata.playMusicdata.selectPlayer,InfoData.cutYWforSelect);
			//
			mi.showInfo(infodata.playMusicdata);
		}		
		
		/**
		 * 其他操作yw的时候，修改 鱼丸数 
		 * @param pd
		 * 
		 */		
		public function changePlaymusicdata(pd:PlayerData):void{
			
		}
		
		
		
		private static var _instant:CurrPlayerMusicCtrl;
		public static function get instant():CurrPlayerMusicCtrl
		{
			if( null == _instant )
			{
				_instant = new CurrPlayerMusicCtrl();
			}
			return _instant;
		}
	}
}