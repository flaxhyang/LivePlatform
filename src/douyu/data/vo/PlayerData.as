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
		public var currYW:Number=0;//当前鱼丸数
		public var THMessage:String="";//鱼丸榜留言
		public var notice:String="";//点歌 喇叭
		
		
		/**
		 * 1:点歌的人
		 * 2：送礼物的人
		 * 3：扣鱼丸的人
		 */	
		public var OperationType:int=0;//操作逻辑
		public var OperationYW:int=0;//操作中的鱼丸数
	}
}