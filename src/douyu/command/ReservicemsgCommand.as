/**
 * 弹幕接受 
 */
package douyu.command
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import douyu.ctrl.AuthorityCtrl;
	import douyu.ctrl.THTopCtrl;
	import douyu.data.InfoData;
	import douyu.data.vo.MusicData;
	import douyu.data.vo.PlayerData;
	
	public class ReservicemsgCommand extends EventDispatcher
	{
		
		private var linkTestnum:int=0;
		
		private var pattern:RegExp=/[0-9]+/;
		private var exp:RegExp=/\s/g;
		private var exp2:RegExp=new RegExp("[`~!@#$+^&*()-=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]"); 
		
		private var smc:selectMusicCommand=selectMusicCommand.instant;
		private var gc:GiftCommand=GiftCommand.instant;
		private var ac:AuthorityCtrl=AuthorityCtrl.instant;
		private var thtc:THTopCtrl=THTopCtrl.instant;
		private var infodata:InfoData=InfoData.instant;
		
		private var currid:int;
		private var currnick:String;
		
		public function ReservicemsgCommand(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function decodeMsg(id:int,nick:String,msg:String):void{
			//链接成功发个消息
			if(nick=="猫小胖杂货铺"){
				if(linkTestnum>1){	
					return;
				}
				linkTestnum++;
			}
			currid=int(id);
			currnick=nick;
			
			if(msg.indexOf("切歌")==0){
				
				//如果是超级权限直接切歌
				if(ac.isId(currid)){
					//切歌
					smc.stopMusic();
					return;
				}
				
				var thnum:int=thtc.isTH(currid);//切歌人的土豪排行
				var currnum:int;
				if(thnum>-1){
					if(infodata.playMusicdata.selectPlayer==null){
						smc.stopMusic();
						return;
					}else{
						currnum=thtc.isTH(infodata.playMusicdata.selectPlayer.id);//当前播放歌曲人的 土豪排行
						if(currnum==-1 || thnum<=currnum){
							smc.stopMusic();
							return;
						}
					}
				}
				//切歌失败
				
				
			}
			
			//去掉空格
			msg=msg.replace(exp,"");
			
			//判断是否为数字
			if(pattern.test(msg)){
				selectMV(int(msg),currid,currnick);
				return;
			}
			
			//
			if(msg.indexOf("点歌")==0){
				msg=msg.slice(2);
				selectMusic(msg);
				
			}else if(msg.indexOf("点歌:")==0){
				msg=msg.slice(3);
				selectMusic(msg);
			}else{
				var frist:String=msg.charAt();
				if(frist=="#" || frist=="*" || frist=="&" ){
					msg=msg.slice(1);
					selectMusic(msg);
				}
			}
			
			//调用 图灵机器人接口
			if(msg.indexOf("小胖")>0 ||  msg.indexOf("胖猫")>0){
				//http://www.tuling123.com/openapi/api?key=KEY&info=你漂亮么
			}
			 
			
		}
		
		private function selectMusic(msg:String):void{
			if(pattern.test(msg)){
				selectMV(int(msg),currid,currnick);
				return;
			}

			var arr:Array=msg.split(exp2,msg.length);
			if(arr.length==3){
				selectMP3(arr[0],arr[2],currid,currnick);
			}
		}
		
		
		private function  selectMV(no:int,id:int,nick:String):void{
			if(no<300){
				if(!ac.isId(id)){
					return;
				}
			}
			
			var md:MusicData=new MusicData();
			md.ismv=true;
			md.mvid=no;
			var sp:PlayerData=new PlayerData();
			sp.id=id;
			sp.nick=nick;
			md.selectPlayer=sp;
			smc.selectMusic(md);
		}
		
		
		private function selectMP3(Muname:String,player:String,id:int,nick:String):void{
			var md:MusicData=new MusicData();
			md.ismv=false;
			md.mName=Muname;
			md.playerName=player;
			var sp:PlayerData=new PlayerData();
			sp.id=id;
			sp.nick=nick;
			md.selectPlayer=sp;
			smc.selectMusic(md);
		}
		
		
		private static var _instant:ReservicemsgCommand;
		
		public static function get instant():ReservicemsgCommand
		{
			if( null == _instant )
			{
				_instant = new ReservicemsgCommand();
			}
			return _instant;
		}
	}
}