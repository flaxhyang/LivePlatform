/**
 *  点歌 逻辑
 */
package douyu.command
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.ctrl.CtrlVideo;
	import douyu.ctrl.MP3Ctrl;
	import douyu.ctrl.SelectMusicTopCtrl;
	import douyu.data.InfoData;
	import douyu.data.vo.MusicData;
	import douyu.database.DataBase;
	
	
	public class selectMusicCommand extends EventDispatcher
	{

		private var isSelecting:Boolean=false;
		
		private var TempSelectPlayerRow:Vector.<MusicData>=new Vector.<MusicData>();
		
		private var mp3ctrl:MP3Ctrl=MP3Ctrl.instant;
		private var ctrlvideo:CtrlVideo=CtrlVideo.instant;
		private var smc:SelectMusicTopCtrl=SelectMusicTopCtrl.instant;
		private var smtc:SelectMuTopCommand=SelectMuTopCommand.instant;
		private var plc:PlayAutoListCommand=PlayAutoListCommand.instant;
		
		private var ifdt:InfoData=InfoData.instant;
		private var db:DataBase=DataBase.instant;
	
		
		public function selectMusicCommand(target:IEventDispatcher=null)
		{
			super(target);
			init();
		}

		/**
		 * 点歌
		 * @param md
		 */		
		public function selectMusic(md:MusicData):void{
			TempSelectPlayerRow.push(md);
			selectNextMusic();
		}
		
		//---------------------------------------------------------------------------
		private function init():void{
			//
			ifdt.addEventListener(InfoData.MUSIC_PLAY_COMPLETE,musicPlayComplete);
			ifdt.addEventListener(InfoData.MUSIC_NOT_FIND,musicSearchOver);
			ifdt.addEventListener(InfoData.MUSIC_FIND_OK,nextPlayerMusic);
			ifdt.addEventListener(InfoData.NEW_SELECT_MUSIC_DATA,newMusicHandle);
			ifdt.addEventListener(InfoData.DELET_MUSIC_DATA,deletMusicdataHnadle);
			//
		}
		
		protected function deletMusicdataHnadle(event:Event):void
		{
			smc.delectMusic(ifdt.deletSeleteMusicPid);
		}
		
		
		/**
		 * 搜寻下首排队歌曲
		 * @param event
		 */		
		protected function musicSearchOver(event:Event=null):void
		{
			isSelecting=false;
			if(TempSelectPlayerRow.length>0){
				selectNextMusic();
			}
		}
		
		protected function musicPlayComplete(event:Event):void
		{
			PlayNextMusic();
			
		}
		
		/**
		 * 点歌榜 有新点歌
		 * @param event
		 */		
		protected function newMusicHandle(event:Event):void
		{
//			trace("2")
			//是否切断歌曲
//			trace("new music!")
			var isStop:Boolean=false;
			
			//显示点歌榜逻辑
			var newMD:MusicData=ifdt.getMusicData(ifdt.rowMusicData.length-1);
			if(newMD.selectPlayer!=null){
				smtc.addNewOP(newMD.selectPlayer,1);
			}
			
			if(ifdt.playMusicdata.selectPlayer == null || ifdt.playMusicdata.listSelectPlayer==true){
				cutMusic();
			}
			
			//搜寻 下一首
			musicSearchOver();
			return;
		}		
		
		//------------------------------------play  music
		private function PlayNextMusic():void{
			if(ifdt.rowMusicData.length>0){
				var md:MusicData=ifdt.deleteSTMusicData(0);
				playmusic(md);
			}else if(ifdt.thRowMusicData.length>0){
				selectMusic(ifdt.thRowMusicData.shift());
			}else{
				selectMusic(plc.playAutoList())
			}
		}
		
		
		private function nextPlayerMusic(evt:Event):void{
			isSelecting=false;
			playmusic(ifdt.playMusicdata);
		}
		/**
		 * 播放歌曲
		 * @param md
		 */		
		private function playmusic(md:MusicData):void{
			ifdt.playMusicdata=md;
			if(md.ismv){
				ctrlvideo.play(InfoData.MTVURL+md.musicUrl);
			}else{
				mp3ctrl.playMp3(md);
			}
		}
		
		//点歌搜寻
		private function selectNextMusic():void{
			if(isSelecting){return}
			isSelecting=true;
			var tmd:MusicData=TempSelectPlayerRow.shift();
			if(tmd.ismv){
				ctrlvideo.selectVideo(tmd);
			}else{
				mp3ctrl.SearchMp3(tmd);
			}
		}
		
		
		/**
		 * 停止 music 
		 */		
		private function  stopMusic():void{
			if(ifdt.playMusicdata.ismv){
				ctrlvideo.stop();					
			}else{
				mp3ctrl.stopMp3();
			}
		}
		
		
		/**
		 *  切歌 
		 */		
		public function cutMusic():void{
			stopMusic();
			PlayNextMusic();
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