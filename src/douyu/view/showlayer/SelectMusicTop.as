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
	import flash.net.dns.AAAARecord;
	
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
		
//		private var showTop:Vector.<int>=new Vector.<int>();
//		private var tiaoArr:Vector.<Tiao>=new Vector.<Tiao>();
		
//		private var tiaoCurrNo:int;//要移动的条的数组位置
		
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
		
		
		private var showTiaoArr:Vector.<Tiao>=new Vector.<Tiao>();
		
		public function showTiao(pid:int):void{
			var fromStep:int=0;
			var toStep:int=0;
			for (var i3:int = 0; i3 < infodata.rowMusicData.length; i3++) 
			{
				if(pid==infodata.rowMusicData[i3].selectPlayer.id){
					fromStep=i3;
					break;
				}
			}
			
			
			//bubble sort
			var tmp:MusicData;	
			for (var i:int = 0; i < infodata.rowMusicData.length; i++) 
			{
				for (var j:int = 0; j < infodata.rowMusicData.length-i-1; j++) 
				{
					if(infodata.rowMusicData[j].selectPlayer.currYW<infodata.rowMusicData[j+1].selectPlayer.currYW){
						tmp=infodata.rowMusicData[j];
						infodata.rowMusicData[j]=infodata.rowMusicData[j+1];
						infodata.rowMusicData[j+1]=tmp;
					}
				}
				
			}
			//quickSort
//			quickSort(0,infodata.rowMusicData.length-1);
			
			for (var k:int = 0; k < infodata.rowMusicData.length; k++) 
			{
				if(pid==infodata.rowMusicData[k].selectPlayer.id){
					toStep=k;
					break;
				}
			}
			
			
//			for (var i2:int = 0; i2 < infodata.rowMusicData.length; i2++) 
//			{
//				trace(infodata.rowMusicData[i2].selectPlayer.id)
//			}
//			trace("-------------------"+pid,fromStep,toStep)
//			
			
			
			var isshowNo:int=-1;
			for (var i4:int = 0; i4 < showTiaoArr.length; i4++) 
			{
				if(pid==showTiaoArr[i4].solayerId){
					isshowNo=i4;
					break;
				}
			}
			
			if(isshowNo==-1){
				//新建
				if(toStep<InfoData.selectMusicTopMax){
					newTiao(pid,toStep);
					showing(toStep);
				}else{
					opreationOver();
				}
			}else if(fromStep>toStep){
				//向上
				
				//移动后的位置 没到显示位置
				if(toStep>InfoData.selectMusicTopMax){
					opreationOver();
					return;
				}
				
				
				//移动的条是否需要新建
				if(fromStep>InfoData.selectMusicTopMax){
					newTiao(pid,toStep);
					showing(toStep);
				}else{
					moveTiao(fromStep,toStep);
				}
				
				
			}else if(fromStep<toStep){
				//向下
				if(fromStep>InfoData.selectMusicTopMax){
					opreationOver();
					return;
				}
				
				if(toStep>InfoData.selectMusicTopMax){
					disTiao(fromStep);
				}else{
					moveTiao(fromStep,toStep);
				}
			}
			opreationOver();
		}
		
		
		public function deletTiao(id:int):void{
			var currnum:int=-1;
			for (var i:int = 0; i < showTiaoArr.length; i++) 
			{
				if(id==showTiaoArr[i].solayerId){
					currnum=i;
					break;
				}
			}
			
			if(currnum>-1){
				disTiao(currnum);
			}else{
				opreationOver();
			}
			
		}
		
		
		private function newTiao(pid:int,No:int):void{
			var tiao:Tiao=new Tiao(backbitmapdata);
			var mu:MusicData=infodata.getMusicData(infodata.getPlayerNum(pid));
			tiao.setWord(mu.selectPlayer.id,mu.selectPlayer.nick,mu.mName,mu.selectPlayer.currYW);
			showTiaoArr.splice(No,0,tiao);
			tiao.y=No*Yspase;
			tiao.x=sceenRect.width;
			this.addChild(tiao);
		}
		
		
		private function moveTiao(fromStep:int,toStep:int):void{
			var movetiao:Tiao=showTiaoArr.splice(fromStep,1)[0];
			showTiaoArr.splice(toStep,0,movetiao);
			
			var No:int=fromStep>toStep?toStep:fromStep;
			showing(No);
		}
		
		private function showing(No:int):void{
			var xmove:int=0;
			for (var i:int = No; i < showTiaoArr.length; i++) 
			{
				//				trace("ywnum="+tiaoArr[i].ywNum);
				xmove=0;
				if(showTiaoArr[i].ywNum<=0){
					xmove=120;
				}
				//				trace("xmove="+xmove);
				if(i==showTiaoArr.length-1){
					TweenLite.to(showTiaoArr[i],0.8,{y:i*Yspase,x:xmove,ease:Back.easeInOut,onComplete:moveComplete});
				}else{
					TweenLite.to(showTiaoArr[i],0.8,{y:i*Yspase,x:xmove,ease:Back.easeInOut});
				}
			}
		}
		
		private function disTiao(no:int):void{
			var deTiao:Tiao=showTiaoArr.splice(no,1)[0];
			TweenLite.to(deTiao,0.6,{alpha:0,onComplete:function deleComplete():void{
				deTiao.parent.removeChild(deTiao);
				
				var need:int=InfoData.selectMusicTopMax-showTiaoArr.length;
				
				for (var i:int = 1; i <= need; i++) 
				{
					var newnum:int=showTiaoArr.length;
					if(newnum<=infodata.rowMusicData.length-1){
						newTiao(infodata.rowMusicData[newnum].selectPlayer.id,newnum);
					}
					
				}
				
				showing(no);
			}});
		}
		
		private function opreationOver():void{
			this.dispatchEvent(new Event(MOVE_COMPLETE));
		}
		
		
		private function moveComplete():void{
			deletMaxLimit();
			agaSort();
			this.dispatchEvent(new Event(MOVE_COMPLETE));
		}
		
		private function agaSort():void{
			for (var i:int = 0; i < showTiaoArr.length; i++) 
			{
				showTiaoArr[i].setNo(i);
			}	
		}
		
		private function deletMaxLimit():void{
			
			while(showTiaoArr.length>InfoData.selectMusicTopMax){
				disTiao(showTiaoArr.length-1);
			}
			
		}
		
		
		
		
		private function quickSort(start:int,end:int):void{
			if(start<end){
				var i:int=start;
				var j:int=end;
				while(i<j){
					
					var vi:int=infodata.rowMusicData[i].selectPlayer.currYW;
					var vj:int=	infodata.rowMusicData[j].selectPlayer.currYW;
					
					while(i<j && infodata.rowMusicData[i].selectPlayer.currYW>=infodata.rowMusicData[j].selectPlayer.currYW)
					{
						j--;
					}
					if(infodata.rowMusicData[i].selectPlayer.currYW<infodata.rowMusicData[j].selectPlayer.currYW){
						swap(i,j)
					}
					
					while(i<j&&infodata.rowMusicData[i].selectPlayer.currYW>infodata.rowMusicData[j].selectPlayer.currYW) 
					{
						i++;
					}
					
					if(infodata.rowMusicData[i].selectPlayer.currYW<infodata.rowMusicData[j].selectPlayer.currYW){
						swap(i,j)
					}
					
				}
				if(i-start>1){
					quickSort(start,i-1);
				}
				if(end-i>1){
					quickSort(i+1,end);
				}
				
			}
		}
		
		private function swap(i:int,j:int):void{
			var temp:MusicData;
			temp=infodata.rowMusicData[i];
			infodata.rowMusicData[i]=infodata.rowMusicData[j];
			infodata.rowMusicData[j]=temp;
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
