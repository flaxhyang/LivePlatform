package douyu.tool
{
	import flash.utils.setTimeout;
	
	import douyu.command.GiftCommand;
	import douyu.command.selectMusicCommand;
	import douyu.data.vo.MusicData;
	import douyu.data.vo.PlayerData;

	public class Test
	{
		
		
		private var smc:selectMusicCommand=selectMusicCommand.instant;
		private var gc:GiftCommand=GiftCommand.instant;
		
		public function Test()
		{
		}
		
		public function test():void{
			
			//			return;
			//temp
			var md:MusicData=new MusicData();
			md.ismv=false;
			md.mName="屌丝之歌";
			md.playerName="花粥";
			//			md.ismv=true;
			//			md.mvid=301;
			
			var sp:PlayerData=new PlayerData();
			sp.id=212467;
			sp.nick="flaxhyang";
			md.selectPlayer=sp;
			
			smc.selectMusic(md);
			
			
			//			
			
			return;
			
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				//				md.mName="屌丝之歌";
				//				md.playerName="花粥";
				
				md.ismv=true;
				md.mvid=386;
				
				var sp:PlayerData=new PlayerData();
				sp.id=9557731;
				sp.nick="不变的调调";
				//				sp.id=1;
				//				sp.nick="调调";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
			},3100);
			
			//			return;
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				//				md.mName="一次就好";
				//				md.playerName="杨宗纬";
				
				md.ismv=true;
				md.mvid=386;
				
				var sp:PlayerData=new PlayerData();
				sp.id=1;
				sp.nick="1";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
				
			},3200)
			
			//			return
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				//				md.mName="一次就好";
				//				md.playerName="杨宗纬";
				
				md.ismv=true;
				md.mvid=386;
				
				var sp:PlayerData=new PlayerData();
				sp.id=2;
				sp.nick="2";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
				
			},3300)
			
			//			return
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				//				md.mName="一次就好";
				//				md.playerName="杨宗纬";
				
				md.ismv=true;
				md.mvid=386;
				
				var sp:PlayerData=new PlayerData();
				sp.id=3;
				sp.nick="3";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
				
			},3400)
			
			
			//			return
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				//				md.mName="一次就好";
				//				md.playerName="杨宗纬";
				
				md.ismv=true;
				md.mvid=386;
				
				var sp:PlayerData=new PlayerData();
				sp.id=4;
				sp.nick="4";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
				
			},3500)
			
			//			return;
			
			
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				//				md.mName="一次就好";
				//				md.playerName="杨宗纬";
				
				md.ismv=true;
				md.mvid=386;
				
				var sp:PlayerData=new PlayerData();
				sp.id=5;
				sp.nick="5";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
				
			},3600)
			
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				//				md.mName="一次就好";
				//				md.playerName="杨宗纬";
				
				md.ismv=true;
				md.mvid=386;
				
				var sp:PlayerData=new PlayerData();
				sp.id=5;
				sp.nick="5";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
				
			},4500)
			
			
			setTimeout(function():void{
				gc.gift_fish("212467","5",9)
			},9000);
			
			return;
			
			//			return;
			
			
			//			setTimeout(function():void{
			//				gc.gift_fish("5","5",9)
			//			},3200);
			
			//			return;
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				//				md.mName="一次就好";
				//				md.playerName="杨宗纬";
				
				md.ismv=true;
				md.mvid=386;
				
				var sp:PlayerData=new PlayerData();
				sp.id=6;
				sp.nick="6";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
				
			},3700)
			
			//			return;
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				//				md.mName="一次就好";
				//				md.playerName="杨宗纬";
				
				md.ismv=true;
				md.mvid=386;
				
				var sp:PlayerData=new PlayerData();
				sp.id=7;
				sp.nick="7";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
				
			},3800)
			
			//			setTimeout(function():void{
			//				gc.gift_fish("6","6",9)
			//			},10000);
			//			
			//			return;
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				//				md.mName="一次就好";
				//				md.playerName="杨宗纬";
				
				md.ismv=true;
				md.mvid=386;
				
				var sp:PlayerData=new PlayerData();
				sp.id=8;
				sp.nick="8";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
				
			},3900)
			
			
			
			
			//			return 
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				//				md.mName="一次就好";
				//				md.playerName="杨宗纬";
				
				md.ismv=true;
				md.mvid=386;
				
				var sp:PlayerData=new PlayerData();
				sp.id=10;
				sp.nick="10";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
				
			},4000)
			
			
			
			//			setTimeout(function():void{
			//				gc.gift_fish("9","9",9)
			//			},3200);
			
			//			return;
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				//				md.mName="一次就好";
				//				md.playerName="杨宗纬";
				
				md.ismv=true;
				md.mvid=386;
				
				var sp:PlayerData=new PlayerData();
				sp.id=11;
				sp.nick="11";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
				
			},4100)
			
			//			return;
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				//				md.mName="一次就好";
				//				md.playerName="杨宗纬";
				
				md.ismv=true;
				md.mvid=386;
				
				var sp:PlayerData=new PlayerData();
				sp.id=12;
				sp.nick="12";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
				
			},4200)
			
			//			return
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				//				md.mName="一次就好";
				//				md.playerName="杨宗纬";
				
				md.ismv=true;
				md.mvid=386;
				
				var sp:PlayerData=new PlayerData();
				sp.id=6;
				sp.nick="6";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
				
			},4300)
			
			return
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				md.mName="一次就好";
				md.playerName="杨宗纬";
				
				//							md.ismv=true;
				//							md.mvid=386;
				
				var sp:PlayerData=new PlayerData();
				sp.id=1;
				sp.nick="1";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
				
			},6200)
			
			
			//			setTimeout(function():void{
			//				gc.gift_fish("5","5",9)
			//			},7000);
			
			return;
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				md.mName="一次就好";
				md.playerName="杨宗纬";
				
				//							md.ismv=true;
				//							md.mvid=386;
				
				var sp:PlayerData=new PlayerData();
				sp.id=212467;
				sp.nick="flaxhyang";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
				
			},3200)
			
			
			
			
			setTimeout(function():void{
				var md:MusicData=new MusicData();
				md.ismv=false;
				//				md.mName="屌丝之歌";
				//				md.playerName="花粥";
				
				md.ismv=true;
				md.mvid=301;
				
				var sp:PlayerData=new PlayerData();
				sp.id=212467;
				sp.nick="flaxhyang";
				md.selectPlayer=sp;
				
				smc.selectMusic(md);
				
			},14000)
			
			//			return;
			
			setTimeout(function():void{
				gc.gift_fish("212467","flaxhyang",9)
			},15000);
			
			

		}
		
		
		
		private static var _instant:Test;
		
		public static function get instant():Test
		{
			if( null == _instant )
			{
				_instant = new Test();
			}
			return _instant;
		}
	}
}