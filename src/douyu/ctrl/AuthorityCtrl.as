/**
 * 超级权限 
 */
package douyu.ctrl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import douyu.data.InfoData;
	
	
	public class AuthorityCtrl extends EventDispatcher
	{
		public static const AUTHORITY_LOAD_COMPLETE:String="authority_load_complete";
		
		private var ids:Vector.<int>=new Vector.<int>();
		
		public function AuthorityCtrl(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function init():void{
			var textload:URLLoader=new URLLoader();
			var txtURLRequest:URLRequest=new URLRequest(InfoData.AuthorityURL);
			textload.addEventListener(Event.COMPLETE,authorityHandle);
			textload.load(txtURLRequest);	
		}
		
		protected function authorityHandle(event:Event):void
		{
			var autArr:Array=String(event.target.data).split(",");
			for (var i:int = 0; i < autArr.length; i++) 
			{
				ids.push(int(autArr[i]));
			}
			
//			this.dispatchEvent(new Event(AUTHORITY_LOAD_COMPLETE));
		}	
		
		//检查是否为超级权限
		public function isId(id:int):Boolean{
			var istrue:Boolean=false;
			for (var i:int = 0; i < ids.length; i++) 
			{
				if(id==ids[i]){
					return true;
				}	
			}
			return false;
		}
		
		
		private static var _instant:AuthorityCtrl;
		public static function get instant():AuthorityCtrl
		{
			if( null == _instant )
			{
				_instant = new AuthorityCtrl();
			}
			return _instant;
		}
	}
}