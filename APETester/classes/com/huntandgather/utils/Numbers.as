package com.huntandgather.utils
{
	public class Numbers
	{
		public function Numbers()
		{
		}
		
		public static function thousands(num:*):String
		{
			if(Number(num) >= 1000 || Number(num) <= -1000)
			{
				
				var str:String = String(num);
				if(Number(num) < 0) str.substr(1, str.length-1);
				var arr:Array = str.split("");
	//			arr.reverse();
				
				var finalArr:Array = new Array();
				
				while(arr.length > 0)
				{
					var nums:Array = arr.splice(-3, 3);
					finalArr.push(nums.join(""));
				}
				
				finalArr.reverse();
				str = finalArr.join(",");
				if(Number(num) < 0) str = "-" + str;
				
				return str;
			}
			return String(num);
		}
		
		//*** random number generator ***//
		public static function randRange(min:Number, max:Number, round:Boolean=true):Number
		{
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
			if(round) Math.round(randomNum);
			return randomNum;
		}
		
		// takes 3 0-255 colors and converts to string "0xXXXXXX"
//		public static function RBGtoHEX(r:Number, g:Number, b:Number, prefix:String="0x"):String
//		{
//			// should add error checking for values over 255 and under 0
//			r = r.toString(16);
//			g = g.toString(16);
//			b = b.toString(16);
//			r = (r.length < 2) ? "0"+r : r;
//			g = (g.length < 2) ? "0"+g : g;
//			b = (b.length < 2) ? "0"+b : b;
//			return String("0x"+(r+g+b)).toUpperCase();
//		}

	}
}