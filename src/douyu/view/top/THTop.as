package douyu.view.top
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
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
		private var topW:int=505;
		private var topH:int=200;
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
			var title:THTiao=new THTiao();
			this.addChild(title);
			title.init();
			title.setText("No","土豪","鱼丸","留言");
			title.x=27;
			
			//
			thsp=new Sprite();
			this.addChild(thsp);
			
			var masksp:Shape=new Shape();
			masksp.graphics.beginFill(0,0);
			masksp.graphics.drawRect(0,0,title.width+2,topH-THTiao.TiaoHeight-2);
			masksp.graphics.endFill();
			this.addChild(masksp);
			masksp.y=thsp.y=THTiao.TiaoHeight+1;
			masksp.x=thsp.x=title.x;
			thsp.mask=masksp;
			
			TweenMax.to(thsp,10,{y:-105,yoyo:true,repeat:-1,repeatDelay:3,ease:Linear.easeNone});
		}
		
		
		public function setData(data:Vector.<PlayerData>):void{
			for (var i:int = 0; i < data.length; i++) 
			{
				var currt:THTiao=new THTiao();
				currt.init();
				thsp.addChild(currt);
				currt.setText(String(i+1),data[i].nick,String(data[i].totleYW),data[i].THMessage);
				currt.y=i*THTiao.TiaoHeight;
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