package douyu.view.top
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import douyu.data.InfoData;
	
	public class THTiao extends Sprite
	{
		private var No1tf:TextFormat;
		private var No2tf:TextFormat;
		private var No3tf:TextFormat;
		private var tf2:TextFormat;
		private	var NumText:TextField;
		private var nameText:TextField;
		private var ywText:TextField;
		private var lyText:TextField;
		
		private var th:int;
		private var thisNo:int;
		
		public function THTiao(No:int,height:int=24)
		{
			super();
			th=height;
			thisNo=No;
			this.mouseEnabled=false;
			this.mouseChildren=false;
			this.cacheAsBitmap=true;
		}
		public function init():void
		{
			No1tf=new TextFormat(InfoData.fontNames,12,0x00ff00,true);
			No1tf.align=TextFormatAlign.CENTER;
			
			No2tf=new TextFormat(InfoData.fontNames,12,0xffff00,true);
			No2tf.align=TextFormatAlign.CENTER;
			
			No3tf=new TextFormat(InfoData.fontNames,12,0xffff00,true);
			No3tf.align=TextFormatAlign.CENTER;
			
			tf2=new TextFormat(InfoData.fontNames,12,0xffffff,true);
			tf2.align=TextFormatAlign.CENTER;
			
			NumText=new TextField();
			this.addChild(NumText);
			NumText.width=20;
			NumText.height=th;
			NumText.border=true;
			NumText.borderColor=0x000000;
			NumText.background=true;
			NumText.backgroundColor=0x262b2d;
			NumText.wordWrap=true;
			
			nameText=new TextField();
			this.addChild(nameText);
			nameText.width=80;
			nameText.height=th;
			nameText.x=20;
			nameText.border=true;
			nameText.borderColor=0x000000;
			nameText.background=true;
			nameText.backgroundColor=0x262b2d;
			
			
			nameText.wordWrap=true;
			
			ywText=new TextField();
			this.addChild(ywText);
			ywText.width=70;
			ywText.height=th;
			ywText.x=100;
			ywText.border=true;
			ywText.borderColor=0x000000;
			ywText.background=true;
			ywText.backgroundColor=0x262b2d;
			ywText.wordWrap=true;
			
			lyText=new TextField();
			this.addChild(lyText);
			lyText.width=205;
			lyText.height=th;
			lyText.x=170;
			lyText.border=true;
			lyText.borderColor=0x000000;
			lyText.background=true;
			lyText.backgroundColor=0x262b2d;
			lyText.defaultTextFormat=tf2;
			lyText.wordWrap=true;
			
			switch(thisNo)
			{
				case 0:
				{
					NumText.defaultTextFormat=No1tf;
					nameText.defaultTextFormat=No1tf;
					ywText.defaultTextFormat=No1tf;
					break;
				}
				case 1:
				{
					NumText.defaultTextFormat=No2tf;
					nameText.defaultTextFormat=No2tf;
					ywText.defaultTextFormat=No2tf;	
					break;
				}
				case 2:
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
		
		public function setText(no:String,names:String,yw:String,ly:String,iswrap:Boolean=true):void{
			
			NumText.text="";
			nameText.text="";
			ywText.text="";
			lyText.text="";
			//
			NumText.text=no;
			//
			nameText.text=names;
		
			if(iswrap){
				ywText.text=String(Number(yw)*100);
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