package douyu.vo
{
	public class MTVInfo
	{
		public function MTVInfo()
		{
		}
		private var _No:int;
		private var _name:String;
		private var _type:int;
		private var _chooseNum:int;
		private var _image:String;
		private var _url:String;
		private var _id:int;

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}


		public function get No():int
		{
			return _No;
		}

		public function set No(value:int):void
		{
			_No = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

		public function get chooseNum():int
		{
			return _chooseNum;
		}

		public function set chooseNum(value:int):void
		{
			_chooseNum = value;
		}

		public function get image():String
		{
			return _image;
		}

		public function set image(value:String):void
		{
			_image = value;
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}


	}
}