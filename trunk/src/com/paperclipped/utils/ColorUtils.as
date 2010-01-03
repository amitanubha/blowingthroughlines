package com.paperclipped.utils
{
	import com.paperclipped.utils.Numbers;

	public class ColorUtils extends Numbers
	{	
		/**
		 * Accepts a color as a String in any legal html / flash format
		 * @param color		String "0x123456" or "#123456"
		 * @return 			Proper number as 0x123456 (1193046)
		 */		
		public static function colorFromHexString(color:String):Number
		{
			return Number(color.replace("#", "0x"));
		}
		
		/**
		 * Accepts a color as a Number or uint, and returns a HTML/CSS like string
		 * @param color		Number 0x123456 or 1193046
		 * @return 			String "#123456"
		 */		
		public static function colorToHexString(color:Number):String
		{
			var hexColor:String = color.toString(16);
			while(hexColor.length < 6) hexColor = "0"+hexColor;
			return "#" + hexColor.toUpperCase();
		}
		// takes 3 0-255 colors and converts to string "0xXXXXXX"
		
		/**
		 *  
		 * @param r 		Number from 0-255
		 * @param g 		Number from 0-255
		 * @param b 		Number from 0-255
		 * @param prefix	String "0x" or "#" depending on where you want to use it.
		 * @return 			String prefix + 
		 */		
		public static function RBGtoHEX(r:Number=0, g:Number=0, b:Number=0, prefix:String="0x"):String
		{
			var rStr:String = (r < 255) ? (r > 0) ? r.toString(16) : "FF" : "00";
			var gStr:String = (g < 255) ? (g > 0) ? g.toString(16) : "FF" : "00";
			var bStr:String = (b < 255) ? (b > 0) ? b.toString(16) : "FF" : "00";
			
			rStr = (rStr.length < 2) ? "0"+rStr : rStr;
			gStr = (gStr.length < 2) ? "0"+gStr : gStr;
			bStr = (bStr.length < 2) ? "0"+bStr : bStr;
			
			return String(prefix+(rStr+gStr+bStr)).toUpperCase();
		}
	}
}