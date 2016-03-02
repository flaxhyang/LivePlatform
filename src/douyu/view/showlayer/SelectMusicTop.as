package douyu.view.showlayer
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import douyu.data.ImageData;
	import douyu.data.InfoData;
	import douyu.data.vo.MusicData;
	
	
	public class SelectMusicTop extends Sprite
	{
		public static const MOVE_COMPLETE:String="move_complete";
		
		private const Yspase:int=38;
		
		private var infodata:InfoData=InfoData.instant;
		
		private const sceenRect:Rectangle=new Rectangle(0,0,468,400);
		private var showSpMask:Shape;
		private var showSp:Sprite;
		
		private var backbitmapdata:BitmapData;
		
		private var showTop:Vector.<int>=new Vector.<int>();
		private var tiaoArr:Vector.<Tiao>=new Vector.<Tiao>();
		
		
		private var tiaoCurrNo:int;//要移动的条的数组位置
		
		public function SelectMusicTop()
		{
			super();
			init();
		}
		
		private function init():void{
			backbitmapdata=new ImageData.dgbackClass().bitmapData;
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
				showTop.push(playerId);
				createTiao(movestep);
				moveTiao(movestep,movestep);
			}else{
				for (var i:int = 0; i < tiaoArr.length; i++) 
				{
					if(playerId==tiaoArr[i].solayerId){
						tiaoArr[i].setYW(infodata.rowMusicData[movestep].selectPlayer.currYW);
						tiaoArr[i].setMusicName(infodata.rowMusicData[movestep].mName);
						tiaoCurrNo=i;
						break;
					}
				}
				
				moveTiao(tiaoCurrNo,movestep);
			}	
			
			
		}
		
		public function deletTiao(No:int=0):void{
			if(tiaoArr.length==0)return;
			var deletTiao:Tiao=tiaoArr[No];
			showTop.splice(showTop.indexOf(deletTiao.solayerId),1);
			this.removeChild(deletTiao);
			tiaoArr.splice(No,1);
			if(tiaoArr.length>0){
				downTiao(No);
			}
		}
		
		
		
		private function moveTiao(fromNo:int,toNo:int):void{
			var movetiao:Tiao=tiaoArr.splice(fromNo,1)[0];
			tiaoArr.splice(toNo,0,movetiao);
			var beginNo:int=fromNo>toNo?toNo:fromNo;
			downTiao(beginNo);
		}
		
		private function downTiao(No:int):void{
			var xmove:int=0;
			for (var i:int = No; i < tiaoArr.length; i++) 
			{
//				trace("ywnum="+tiaoArr[i].ywNum);
				xmove=0;
				if(tiaoArr[i].ywNum<=0){
					xmove=120;
				}
//				trace("xmove="+xmove);
				if(i==tiaoArr.length-1){
					TweenLite.to(tiaoArr[i],0.8,{y:i*Yspase,x:xmove,ease:Back.easeInOut,onComplete:moveComplete});
				}else{
					TweenLite.to(tiaoArr[i],0.8,{y:i*Yspase,x:xmove,ease:Back.easeInOut});
				}
			}
		}
		
		private function createTiao(No:int):void{
			var tiao:Tiao=new Tiao(backbitmapdata);
			var mu:MusicData=infodata.rowMusicData[No];
			tiao.setWord(mu.selectPlayer.id,mu.selectPlayer.nick,mu.mName,mu.selectPlayer.currYW);
			tiaoArr.splice(No,0,tiao);
			tiao.y=No*Yspase;
			tiao.x=sceenRect.width;
			this.addChild(tiao);
		}
		
		
		private function moveComplete():void{
			agaSort();
			this.dispatchEvent(new Event(MOVE_COMPLETE));
		}
		
		private function agaSort():void{
			for (var i:int = 0; i < tiaoArr.length; i++) 
			{
				tiaoArr[i].setNo(i);
				
			}	
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
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

import douyu.data.InfoData;

class Tiao extends Sprite{
	
	private var TF:TextFormat=new TextFormat(InfoData.fontNames,14,0xffffff);
	private var No:TextField;
	private var selectPlayer:TextField;
	private var musicName:TextField;
	private var yw:TextField;
	
	public var solayerId:int;
	public var ywNum:int;
	
	
	public function Tiao(bitmap:BitmapData){
		var matrix:Matrix=new Matrix();
		this.graphics.beginBitmapFill(bitmap,null,false,true);
		this.graphics.drawRect(0,0,bitmap.width,bitmap.height);
		this.graphics.endFill();
	}
	
	public function setWord(spid:int,splayer:String,mname:String,yuwan:int=0):void{
		solayerId=spid;
		ywNum=yuwan;
		
		No=new TextField();
		No.width=50;
		
		selectPlayer=new TextField();
		musicName=new TextField();
		yw=new TextField();
		
		this.addChild(No);
		No.defaultTextFormat=TF;
		No.x=25;
		
		this.addChild(selectPlayer);
		selectPlayer.defaultTextFormat=TF;
		selectPlayer.x=80;
		
		this.addChild(musicName);
		musicName.defaultTextFormat=TF;
		musicName.x=210;
		
		this.addChild(yw);
		yw.defaultTextFormat=TF;
		yw.x=350;
		
		No.y=selectPlayer.y=musicName.y=yw.y=5;
		No.height=selectPlayer.height=musicName.height=yw.height=25;
		
		selectPlayer.text="点播："+splayer;
		musicName.text="歌名："+mname;
		yw.text="本次鱼丸："+(yuwan*100);
	}
	
	public function setNo(num:int):void{
		No.text="No. "+(num+1);
	}
	
	public function setYW(ywnum:int):void{
		ywNum=ywnum;
		yw.text="本次鱼丸："+(ywnum*100);
	}
	
	public function setMusicName(name:String):void{
		musicName.text="歌名："+name;	
	}
	
}
