package douyu.vo
{
	public class SelectMTVPeople
	{
		public function SelectMTVPeople()
		{
		}
		private var _id:int;

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		private var _name:String

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		////////////////////////////////////////////////
		private var _MTVids:String="";

		public function get MTVids():String
		{
			return _MTVids;
		}

		public function set MTVids(value:String):void
		{
			_MTVids = value;
			var mvids:Array=_MTVids.split("&");
			_MTVisVec.splice(0,_MTVisVec.length);
			for (var i:int = 0; i < mvids.length; i++) 
			{
				var mvnum:int=int(mvids[i]);
				if(mvnum){
				_MTVisVec.push(mvnum);
				}
			}
		}
		
		private var _MTVisVec:Vector.<int>=new Vector.<int>();

		public function get MTVisVec():Vector.<int>
		{
			return _MTVisVec;
		}

	

		
//////////////////////////////////////////////////////////////
		private var _sumYW:Number

		public function get sumYW():Number
		{
			return _sumYW;
		}

		public function set sumYW(value:Number):void
		{
			_sumYW = value;
		}
		
		
		
		private var _currYw:Number=0;
		
		public function get currYw():Number
		{
			return _currYw;
		}
		
		public function set currYw(value:Number):void
		{
			_currYw = value;
		}
		
		private var _message:String=null;

		public function get message():String
		{
			return _message;
		}

		public function set message(value:String):void
		{
			_message = value;
		}

		
		private var _leaveWord:String

		public function get leaveWord():String
		{
			return _leaveWord;
		}

		public function set leaveWord(value:String):void
		{
			_leaveWord = value;
		}

		
	}
}