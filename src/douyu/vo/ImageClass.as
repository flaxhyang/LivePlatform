package douyu.vo
{

	public class ImageClass
	{
		public function ImageClass()
		{
		}
		
		private static var _instant:ImageClass;
		
		public static function get instant():ImageClass
		{
			if( null == _instant )
			{
				_instant = new ImageClass();
			}
			return _instant;
		}
	}
}