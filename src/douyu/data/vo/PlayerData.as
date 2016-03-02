package douyu.data.vo
{
	public class PlayerData
	{
		public function PlayerData()
		{
		}
		public var id:int;
		public var nick:String;//
		public var totleYW:Number=0;//鱼丸总数
		

		public var THMessage:String="";//鱼丸榜留言
		public var notice:String="";//点歌 喇叭

		
		//当前鱼丸数
		private var _currYW:Number=0;
		public function get currYW():Number
		{
			return _currYW;
		}
		
		public function set currYW(value:Number):void
		{
			value=value<0?0:value;
			_currYW = value;
		}
		
		
		/**
		 * 1:点歌的人
		 * 2：送礼物的人
		 * 3：扣鱼丸的人
		 */	
		public var OperationType:int=0;//操作逻辑
		public var OperationCutYW:int=0;//减少操作中的鱼丸数
		public var OPerationAddYW:int=0;//增加操作的鱼丸
	}
}