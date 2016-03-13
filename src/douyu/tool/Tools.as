package douyu.tool
{
	public class Tools
	{
		public function Tools()
		{
		}
		public static function getRandom(min:int,max:int):int{
			return Math.floor(Math.random()*(max-min+1)+min);
		} 
		
		//生成一个随机排列的连续数组  vector
		public static function randomArr(arr:*):*
		{
			var outputArr:Vector.<*> = arr.slice();
			var i:int = outputArr.length;
			var temp:*;
			var indexA:int;
			var indexB:int;
			
			while (i)
			{
				indexA = i-1;
				indexB = Math.floor(Math.random() * i);
				i--;
				
				if (indexA == indexB) continue;
				temp = outputArr[indexA];
				outputArr[indexA] = outputArr[indexB];
				outputArr[indexB] = temp;
			}
			
			return outputArr;
		}
		
		
		//打乱现有数组
		public static function getRandomArr(array:Array) : Array{
			var returnArr:Array=new Array();
			var tempArr:Array = new Array();
			while(tempArr.length<array.length)
			{
				var tempNum:int = getRandom(0,array.length-1);
				if( tempArr.indexOf(tempNum) == -1)
				{
					tempArr.push(tempNum);
					returnArr.push(array[tempNum]);
				}
			}
			return returnArr;
		}
		
	}
}