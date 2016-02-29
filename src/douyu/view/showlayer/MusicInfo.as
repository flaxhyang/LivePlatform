package douyu.view.showlayer
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import douyu.data.ImageData;
	import douyu.data.vo.MusicData;
	
	public class MusicInfo extends Sprite
	{
		private var musicName:infoTiao;
		private var musicPlayer:infoTiao;
		private var mvNo:infoTiao;
		
		private var selectPlayerTiao:infoTiao;
		private var ywInfoTiao:infoTiao;
		
		private var tiaoWidth:int; 
		
		public function MusicInfo()
		{
			super();
			musicName=new infoTiao();
			musicPlayer=new infoTiao();
			mvNo=new infoTiao();
			
			selectPlayerTiao=new infoTiao();
			ywInfoTiao=new infoTiao();
			this.addChild(musicName);
			this.addChild(musicPlayer);
			this.addChild(mvNo);
			
			this.addChild(selectPlayerTiao);
			this.addChild(ywInfoTiao);
			
		
			var h:int=musicName.h;
			
			musicPlayer.y=h
			mvNo.y=2*h;
			selectPlayerTiao.y=3*h;
			ywInfoTiao.y=4*h;
		}
		
		public function showInfo(md:MusicData):void{
			
			musicName.showTiao("歌名："+md.mName);
			musicPlayer.showTiao("演唱："+md.playerName);
			if(md.ismv){
				mvNo.showTiao("MV编号："+String(md.mvid));
			}else{
				mvNo.hide();
			}
			
			if(md.selectPlayer!=null){
				selectPlayerTiao.showTiao("点播："+md.selectPlayer.nick);
				setYWTiao(md.selectPlayer.currYW);	
			}else{
				selectPlayerTiao.hide();
				setYWTiao.hide();
			}
		}
		
		public function setYWTiao(yw:int):void{
			if(yw!=0){
				ywInfoTiao.showTiao("本次鱼丸："+yw);
			}else{
				ywInfoTiao.hide();
			}
		}
		
		
		
		
		private static var _instant:MusicInfo;
		
		public static function get instant():MusicInfo
		{
			if( null == _instant )
			{
				_instant = new MusicInfo();
			}
			return _instant;
		}
	}
}
import com.greensock.TweenLite;
import com.greensock.easing.Back;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import douyu.data.ImageData;
import douyu.data.InfoData;

class infoTiao extends Sprite{
	public var h:int=0;
	public var w:int=0;
	private var TFmat:TextFormat=new TextFormat(InfoData.fontNames,14,0xffffff,true,null,null,null,null,TextFormatAlign.RIGHT);
	private var TF:TextField=new TextField();
	
	public function infoTiao(){
		var infobackBitData:BitmapData=new ImageData.mvInfobackClass().bitmapData;
		h=infobackBitData.height;
		w=infobackBitData.width;
		var matrix:Matrix=new Matrix();

		this.graphics.beginBitmapFill(infobackBitData,matrix,false,true);
		this.graphics.drawRect(0,0,infobackBitData.width,infobackBitData.height);
		this.graphics.endFill();
		//
		this.addChild(TF);
		TF.height=h-5;
		TF.y=3;
		TF.defaultTextFormat=TFmat;
		this.x=-w;
	}
	
	
	public function showTiao(s:String):void{
		this.x=-w;
		TF.text=s;
		TF.autoSize=TextFieldAutoSize.RIGHT;
		var num:int=TF.width+80;
		TF.x=w-num;
		TweenLite.to(this,0.8,{x:this.x+num,ease:Back.easeInOut})
	}
	
	public function hide():void{
		this.x=-w;
	}
}