package douyu.command.nextMusic
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.ctrl.CtrlVideo;
	import douyu.ctrl.MP3Ctrl;
	import douyu.data.InfoData;
	import douyu.data.vo.MusicData;
	
	
	public class selectMusicCommand extends EventDispatcher
	{

		private var isSelecting:Boolean=false;
		
		private var TempSelectPlayerRow:Vector.<MusicData>=new Vector.<MusicData>();
		
		private var mp3ctrl:MP3Ctrl=MP3Ctrl.instant;
		private var ctrlvideo:CtrlVideo=CtrlVideo.instant;
		
		private var ifdt:InfoData=InfoData.instant;
		
		public function selectMusicCommand(target:IEventDispatcher=null)
		{
			super(target);
			init();
		}
		
		private function init():void{
			mp3ctrl.addEventListener(MP3Ctrl.SEARCHMP3_PROCESS_COMPLETE,seatchMp3Complete);
			//
			ifdt.addEventListener(InfoData.MUSIC_PLAY_COMPLETE,musicPlayComplete);
			ifdt.addEventListener(InfoData.ROW_MUSIC_CHANGE,NewMusicSelectHandle);
		}
		
		protected function seatchMp3Complete(event:Event):void
		{
			isSelecting=false;
			if(TempSelectPlayerRow.length){
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
		protected function NewMusicSelectHandle(event:Event):void
		{
			
			//排序
			
			
			
			trace("new music!")
			var isStop:Boolean=false;
			//当前播放歌曲 不是点播歌曲
			if(ifdt.playMusicdata.selectPlayer==null){
				isStop=true;
			}				
			
			//当前播放歌曲 不是点播歌曲，是土豪联播歌曲，也可以切换
			if(ifdt.playMusicdata.selectPlayer!=null && ifdt.playMusicdata.listSelectPlayer==true){
				isStop=true;
			}
			
			if(isStop){
				stopMusic();
			}
		}		
		
		//------------------------------------play  music
		private function PlayMusic():void{
			if(ifdt.rowMusicData.length>0){
				var md:MusicData=ifdt.rowMusicData.shift();
				
				ifdt.playMusicdata=md;
				
				if(md.ismv){
					ctrlvideo.play(md.musicUrl);
				}else{
					trace("play mp3")
					mp3ctrl.playMp3(md);
				}
			}else{
				ctrlvideo.play("/douyu/view/video/begin.mp4");
			}
		}
		
		
		
		public function selectMusic(md:MusicData):void{
			TempSelectPlayerRow.push(md);
			if(!isSelecting){
				selectNextMusic();
			}
		}
		
		private function selectNextMusic():void{
			var tmd:MusicData=TempSelectPlayerRow.shift();
			if(tmd.ismv){
				ctrlvideo.selectVideo(tmd);
			}else{
				mp3ctrl.SearchMp3(tmd);
			}
		}
		
		
		private function  stopMusic():void{
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