package douyu.vo
{
	public class TTHVo
	{
		public function TTHVo()
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

		
		private var _thName:String;

		public function get thName():String
		{
			return _thName;
		}

		public function set thName(value:String):void
		{
			_thName = value;
		}

		private var _yuNum:Number=0;

		public function get yuNum():Number
		{
			return _yuNum;
		}

		public function set yuNum(value:Number):void
		{
			_yuNum = value;
		}

	}
}