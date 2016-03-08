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
			ifdt.addEventListener(InfoData.NEW_MUSIC_DATA,newMusicHandle);
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
			PlayMusic();
		}
		
		/**
		 * 
		 * @param event
		 */		
		protected function newMusicHandle(event:Event):void
		{
			//显示点歌榜逻辑
			var newMD:MusicData=ifdt.getMusicData(ifdt.rowMusicData.length-1);
			if(newMD.selectPlayer!=null){
				smtc.addNewOP(newMD.selectPlayer,1);
			}
			//是否切断歌曲
//			trace("new music!")
			var isStop:Boolean=false;
			

			
			if(ifdt.playMusicdata==null){
				isStop=true;
			}else{
				//当前播放歌曲 不是点播歌曲
				if(ifdt.playMusicdata.selectPlayer==null){
					isStop=true;
				}				
				
				//当前播放歌曲 不是点播歌曲，是土豪联播歌曲，也可以切换
//				if(ifdt.playMusicdata.selectPlayer!=null && ifdt.playMusicdata.listSelectPlayer==true){
//					isStop=true;
//				}
			}
			if(isStop){
				stopMusic();
			}
			
			//搜寻 下一首
			musicSearchOver();
			return;
		}		
		
		//------------------------------------play  music
		private function PlayMusic():void{
			if(ifdt.rowMusicData.length>0){
				var md:MusicData=ifdt.deleteSTMusicData(0);
				
				ifdt.playMusicdata=md;
				
				if(md.ismv){
					ctrlvideo.play(InfoData.MTVURL+md.musicUrl);
				}else{
					mp3ctrl.playMp3(md);
				}
			}else{
				//ctrlvideo.play("/douyu/view/video/begin.mp4");
				//判断 土豪 播放列表
				
				//判断自动播放列表
				selectMusic(plc.playAutoList());
			}
		}
		
		
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
		
		
		private function  stopMusic():void{
			if(ifdt.playMusicdata==null){
				ctrlvideo.stop();
				return;
			}
			if(ifdt.playMusicdata.ismv){
				ctrlvideo.stop();					
			}else{
				mp3ctrl.stopMp3();
			}
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