package com.paperclipped.utils
{
	/**
	 * A bunch of methods that come in handy for generating and formatting numbers
	 * @author Collin Reisdorf Copyright (c) 2008
	 * 
	 */	
	public class Numbers
	{
		/**
		 * Filesize units for converting from bytes to kilobytes. 
		 */		
		public static const KB		:Number = 1024;
		/**
		 * Filesize units for converting from bytes to megabytes. 
		 */		
		public static const MB		:Number = 1024 * 1024;
		/**
		 * Filesize units for converting from bytes to gigabytes. 
		 */		
		public static const GB		:Number = 1024 * 1024 * 1024;
		/**
		 * Filesize units for converting from bytes to <a href="http://xkcd.com/394/">baker's kilobytes</a> (9 bits to the byte) . 
		 */		
		public static const KBA		:Number = 1152;
		/**
		 * Rounds to the nearest integer.
		 * @see Math#round()
		 */		
		public static const ROUND	:String = "round";
		/**
		 * Rounds down to the nearest integer.
		 * @see Math#floor()
		 */		
		public static const FLOOR	:String = "floor";
		/**
		 * Rounds up to the nearest integer.
		 * @see Math#ceil()
		 */		
		public static const CEIL	:String = "ceil";
		
		/**
		 * Constant for converting radian to degrees, close enough to
		 * <code>Radians * (180/PI)</code> that it makes no difference.
		 */		
		public static const RADIAN_IN_DEGREES:Number = 57.2957795;
		
		/**
		 * Constant for converting degrees to radians, close enough to
		 * <code>Degrees * (PI/180)</code> that it makes no difference.
		 */		
		public static const DEGREE_IN_RADIANS:Number = 0.0174532925;
		
		/**
		 * Takes a number (or as a  string) and returns that number with commas
		 * for each thousands. 
		 * 
		 * @param 	num 	either a number object or string to be split into thousands.
		 * @return 			String containing commas.
		 */		
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
		
		/**
		 * Random number generator.
		 * 
		 * @param 	min		The minum value returned.
		 * @param 	max		The maximum value returned.
		 * @param 	round 	Optional param to return only round numbers.
		 * @return 			A random number between min &amp; max Always rounded now.
		 * 
		 * @see #randRange2()
		 * @see Math#random()
		 */
		public static function randRange(min:Number, max:Number, round:Boolean=true):Number
		{
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
			if(round) Math.round(randomNum);
			return randomNum;
		}
		
		/**
		 * Random number generator Redux.
		 * 
		 * @param 	min		The minum value returned.
		 * @param 	max		The maximum value returned.
		 * @param 	round 	Optional param to return only round numbers.
		 * @return 			A random number between min &amp; max.
		 */
		public static function randRange2(min:Number, max:Number, round:String="none"):Number
		{
			var randomNum:Number = Math.random() * (max - min + 1) + min;
			if(round != "none") Math[round](randomNum);
			return randomNum;
		}
		
		/**
		 * Round to a number of decimals (Defaults to 2 decimal places)
		 * 
		 * @param valueToRound		The value that will be rounded.
		 * @param numberOfDecimals	The number of decimal places to round to.
		 * @param roundType			Rounding method.
		 * @return 					A number rounded to the number of decimals specified.
		 * 
		 * @see Math#round()
		 * @see Math#floor()
		 * @see Math#ceil()
		 */		
		public static function roundDecimals( valueToRound:Number, numberOfDecimals:int = 2 , roundType:String = "round"):Number
		{
			var factor:int = 1;
			for( var i:int = 0; i < numberOfDecimals; i++ )
			{
				factor *= 10;
			}
			return Math[roundType]( valueToRound * factor ) / factor;
		}
		
		/**
		 * Converts bytes to KB, MB or GB (Really? you're downloading GBs? Sweet.)
		 * 
		 * @param value				The data size in bytes.
		 * @param unit				The filesize Unit to conver to.
		 * @param numberOfDecimals	Nulber of decimals to round to.
		 * @return 					New size in specified unit.
		 * 
		 * @see #KB
		 * @see #MB
		 * @see #GB
		 * @see #KBA
		 * @see #roundDecimals() 
		 */		
		public static function convertDataSize( value:Number, unit:Number, numberOfDecimals:int = 0):Number
		{
			value = value / unit;
			
			return value;
		}
		
		public static function minMax(value:Number, min:Number, max:Number):Number
		{
			value = (value < min)? min : value;
			value = (value > max)? max : value;
			
			return value;
		}
		
		public static function getDistance(min:Number, max:Number):Number
		{
			return max - min;
		}
		
	}
}