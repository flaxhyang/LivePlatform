package douyu.view.showlayer
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import douyu.data.ImageData;
	import douyu.data.InfoData;
	import douyu.data.vo.MusicData;
	
	
	public class SelectMusicTop extends Sprite
	{
		public static const MOVE_COMPLETE:String="move_complete";
		
		private const Yspase:int=80;
		
		private var infodata:InfoData=InfoData.instant;
		
		private const sceenRect:Rectangle=new Rectangle(0,0,500,400);
		private var showSpMask:Shape;
		private var showSp:Sprite;
		
		private var backbitmapdata:BitmapData;
		
		private var showTop:Vector.<int>=new Vector.<int>();
		private var tiaoArr:Vector.<Tiao>=new Vector.<Tiao>();
		
		private var currTiao:Tiao;
		
		public function SelectMusicTop()
		{
			super();
			init();
		}
		
		private function init():void{
			backbitmapdata=new ImageData.dgbackClass().bitmapdata;
			showSp=new Sprite();
			this.addChild(showSp);
			showSpMask=new Shape();
			showSpMask.graphics.beginFill(0);
			showSpMask.graphics.drawRect(sceenRect.x,sceenRect.y,sceenRect.width,sceenRect.height);
			showSpMask.graphics.endFill();
			this.addChild(showSpMask);
			
			showSp.mask=showSpMask;
		}
		
		public function showTiao(playerId:int,movestep:int):void{
			var currStep:int=showTop.indexOf(playerId);
			if(currStep==-1){
				if(movestep>tiaoArr.length){
					downTiao(movestep);					
				}
				showNewTiao(movestep);
			}else{
				moveTiao(currStep,movestep);
			}			
		}
		
		public function deletTiao(No:int=0):void{
			showTop.splice(No,1);
			if(showTop.length>0){
				downTiao(No);
			}
		}
		
		private function showNewTiao(No:int):void{
			createTiao(No);
			TweenLite.to(currTiao,800,{x:0,ease:Back.easeInOut});
		}
		
		private function moveTiao(fromNo:int,toNo:int):void{
			var movetiao:Tiao=tiaoArr.splice(fromNo,1)[0];
			tiaoArr.splice(toNo,0,movetiao);
			var beginNo:int=fromNo>toNo?toNo:fromNo
			downTiao(beginNo);
		}
		
		private function downTiao(No:int):void{
			
			for (var i:int = No; i < tiaoArr.length; i++) 
			{
				TweenLite.to(tiaoArr[i],800,{y:i*Yspase});	
			}
		}
		
		
		private function createTiao(No:int):void{
			var tiao:Tiao=new Tiao(backbitmapdata);
			var mu:MusicData=infodata.rowMusicData[No];
			tiao.setWord(No,mu.selectPlayer.nick,mu.mName,mu.selectPlayer.currYW);
			tiaoArr.push(tiao);
			currTiao=tiao;
			currTiao.y=No*Yspase;
			currTiao.x=sceenRect.width;
			this.addChild(currTiao);
			
		}
		
		private static var _instant:SelectMusicTop;
		
		public static function get instant():SelectMusicTop
		{
			if( null == _instant )
			{
				_instant = new SelectMusicTop();
			}
			return _instant;
		}
		
	}
}


import flash.display.BitmapData;
import flash.display.Sprite;
import flash.text.TextField;

class Tiao extends Sprite{
	
	private var No:TextField;
	private var selectPlayer:TextField;
	private var musicName:TextField;
	private var yw:TextField;
	
	
	public function Tiao(bitmap:BitmapData){
		this.graphics.beginBitmapFill(bitmap,null,false,true);
		this.graphics.drawRect(0,0,bitmap.width,bitmap.height);
		this.graphics.endFill();
	}
	
	public function setWord(no:int,splayer:String,mname:String,yuwan:int):void{
		No=new TextField();
		selectPlayer=new TextField();
		musicName=new TextField();
		yw=new TextField();
		
		this.addChild(No);
		this.addChild(selectPlayer);
		this.addChild(musicName);
		this.addChild(yw);
		
		No.text=no+"";
		selectPlayer.text="点播："+splayer;
		musicName.text="歌名："+mname;
		yw.text="本次鱼丸"+yuwan;
		
	}
	
}
