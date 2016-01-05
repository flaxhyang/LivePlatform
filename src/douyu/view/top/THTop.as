package douyu.view.top
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	
	import douyu.data.ImageData;
	import douyu.data.vo.PlayerData;
	
	public class THTop extends Sprite
	{
		private var topW:int=405;
		private var topH:int=136;
		private var lineColor:int=0x000000;
		private var backColor:int=0x212121;
		//
		private var thsp:Sprite;
		private var textArr:Vector.<THTiao>=new Vector.<THTiao>();
		
		public function THTop()
		{
			super();
		}
		
		public function initView():void{
			var g:Graphics=this.graphics;
			g.lineStyle(2, lineColor, 1);
			g.beginFill(backColor); 
			g.drawRoundRect(0, 0, topW, topH, 10 , 10);
			g.endFill();
			//
			var s:Bitmap=new ImageData.ywsClass();
			this.addChild(s);
			s.x=4;
			s.y=topH-s.height>>1;
			//
			var dsf:DropShadowFilter=new DropShadowFilter();
			dsf.color=0x242424;
			var bf:BevelFilter=new BevelFilter();
			bf.highlightColor=0x424242;
			bf.angle=20;
			this.filters=[dsf,bf];
			//
			var title:THTiao=new THTiao(17);
			this.addChild(title);
			title.init();
			title.setText("No","土豪","鱼丸","留言");
			title.x=27;
			//
			thsp=new Sprite();
			this.addChild(thsp);
			
			
			
			var masksp:Shape=new Shape();
			masksp.graphics.beginFill(0,0);
			masksp.graphics.drawRect(0,0,title.width+2,115);
			masksp.graphics.endFill();
			this.addChild(masksp);
			masksp.y=thsp.y=19;
			masksp.x=thsp.x=title.x;
			
			thsp.mask=masksp;
		}
		
		
		public function setData(data:Vector.<PlayerData>):void{
			for (var i:int = 0; i < data.length; i++) 
			{
				var currt:THTiao=new THTiao();
				currt.init();
				thsp.addChild(currt);
				currt.setText(String(i+1),data[i].nick,String(data[i].totleYW),data[i].THMessage);
				currt.y=i*24;
				textArr.push(currt);	
			}
		}
		
		private static var _instant:THTop;
		
		public static function get instant():THTop
		{
			if( null == _instant )
			{
				_instant = new THTop();
			}
			return _instant;
		}
	}
}