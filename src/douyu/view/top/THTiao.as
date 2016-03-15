package douyu.view.top
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import douyu.data.InfoData;
	
	public class THTiao extends Sprite
	{
		
		public static const TiaoHeight:int=30;
		
		private var No1tf:TextFormat;
		private var No2tf:TextFormat;
		private var No3tf:TextFormat;
		private var tf2:TextFormat;
		private	var NumText:TextField;
		private var nameText:TextField;
		private var ywText:TextField;
		private var lyText:TextField;
		
		private var th:int;
		
		public function THTiao(height:int=30)
		{
			super();
			th=height;
			this.mouseEnabled=false;
			this.mouseChildren=false;
			this.cacheAsBitmap=true;
		}
		public function init():void
		{
			No1tf=new TextFormat(InfoData.fontNames,14,0x00ff00,true);
			No1tf.align=TextFormatAlign.CENTER;
			
			No2tf=new TextFormat(InfoData.fontNames,14,0xffff00,true);
			No2tf.align=TextFormatAlign.CENTER;
			
			No3tf=new TextFormat(InfoData.fontNames,14,0xffff00,true);
			No3tf.align=TextFormatAlign.CENTER;
			
			tf2=new TextFormat(InfoData.fontNames,14,0xffffff,true);
			tf2.align=TextFormatAlign.CENTER;
			
			NumText=new TextField();
			
			NumText.width=30;
			NumText.height=th;
			NumText.border=true;
			NumText.borderColor=0x000000;
			NumText.background=true;
			NumText.backgroundColor=0x262b2d;

			
			nameText=new TextField();
			this.addChild(nameText);
			nameText.width=120;
			nameText.height=th;
			nameText.x=30;
			nameText.border=true;
			nameText.borderColor=0x000000;
			nameText.background=true;
			nameText.backgroundColor=0x262b2d;
			
			
			nameText.wordWrap=true;
			
			ywText=new TextField();
			this.addChild(ywText);
			ywText.width=100;
			ywText.height=th;
			ywText.x=150;
			ywText.border=true;
			ywText.borderColor=0x000000;
			ywText.background=true;
			ywText.backgroundColor=0x262b2d;
			ywText.wordWrap=true;
			
			lyText=new TextField();
			this.addChild(lyText);
			lyText.width=225;
			lyText.height=th;
			lyText.x=250;
			lyText.border=true;
			lyText.borderColor=0x000000;
			lyText.background=true;
			lyText.backgroundColor=0x262b2d;
			lyText.defaultTextFormat=tf2;
			lyText.wordWrap=true;
			
			
			
			this.addChild(NumText);
			
			
			
//			NumText.y= nameText.y=  ywText.y=  lyText.y= 5
			
		}	
		
		private function setFormat(no:int):void{
			switch(no)
			{
				case 1:
				{
					NumText.defaultTextFormat=No1tf;
					nameText.defaultTextFormat=No1tf;
					ywText.defaultTextFormat=No1tf;
					break;
				}
				case 2:
				{
					NumText.defaultTextFormat=No2tf;
					nameText.defaultTextFormat=No2tf;
					ywText.defaultTextFormat=No2tf;	
					break;
				}
				case 3:
				{
					NumText.defaultTextFormat=No3tf;
					nameText.defaultTextFormat=No3tf;
					ywText.defaultTextFormat=No3tf;	
					break;
				}
				default:
				{
					NumText.defaultTextFormat=tf2;
					nameText.defaultTextFormat=tf2;
					ywText.defaultTextFormat=tf2;
					break;
				}
			}
		
		}
		
		public function setText(no:String,names:String,yw:String,ly:String):void{
			
			setFormat(int(no));
			
			NumText.text="";
			nameText.text="";
			ywText.text="";
			lyText.text="";
			//
			NumText.text=no;
			
			//
			nameText.text=names;
		
			var ywnum:Number=Number(yw);
			if(ywnum>0){
				
				if(ywnum>100){
					ywnum=ywnum/100;
					ywText.text=ywnum.toFixed(2)+"w";		
				}else{
					ywnum=ywnum*100;
					ywText.text=int(ywnum)+"";
				}
				
			}else{
				ywText.text=yw;
			}
			//
			if(ly){
				lyText.text=ly;
			}
			
			
		}
	}
}