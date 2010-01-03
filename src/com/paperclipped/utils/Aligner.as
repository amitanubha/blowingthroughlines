package com.paperclipped.utils
{
	import flash.geom.Point;
	
	/**
	 * Takes a string and height, width, or both, and returns the top, middle, 
	 * bottom, left, center or right point.
	 * @author Collin Reisdorf
	 * 
	 */	
	public class Aligner
	{
		
		public static const TOP				:String = "T";
		public static const	MIDDLE			:String = "M";
		public static const BOTTOM			:String = "B";
		public static const LEFT			:String = "L";
		public static const CENTER			:String = "C";
		public static const RIGHT			:String = "R";
		
		/**
		 * For 3D (Coming soon!)
		 */		
		public static const FRONT			:String = "F";
		/**
		 * For 3D (Coming soon!)
		 */	
		public static const BACK			:String = "B";
		
		public static const TOP_LEFT		:String = "TL";
		public static const TOP_CENTER		:String = "TL";
		public static const TOP_RIGHT		:String = "TL";
		public static const MIDDLE_LEFT		:String = "ML";
		public static const MIDDLE_CENTER	:String = "MC";
		public static const MIDDLE_RIGHT	:String = "MR";
		public static const BOTTOM_LEFT		:String = "BL";
		public static const BOTTOM_CENTER	:String = "BC";
		public static const BOTTOM_RIGHT	:String = "BR";
		
		/**
		 * Provide a height and width of the box and a location string to return a 
		 * point with the box. 
		 * 
		 * @param w			The width of the area you'd like the position in.
		 * @param h			The height of the area you'd like the position in.
		 * @param position	String representing the postioning, T, M, B, L, C, R 
		 * 					and combinations of 2 are allowed.
		 * @return 			Point object with the x and y locations of the alignment.
		 * 
		 */		
		public static function getPosition(w:Number=0, h:Number=0, position:String="MC"):Point
		{
			if(position.length > 2) return null;
			position = (position.length < 2)? position+position:position;
			var p:Point = new Point(0,0);
			
			if(h > 0)
				p.y = parsePosition(h, position.substr(0,1));
			else if(w > 0)
				p.x = parsePosition(w, position.substr(0,1));
				
			if(w > 0)
				p.x = parsePosition(w, position.substr(1.1));
			
			trace(w,h,p);
			return p;
		}
		
		private static function parsePosition(num:Number, pos:String):Number
		{
			switch(pos)
			{
				case Aligner.TOP:
				num = 0;
				break;
				case Aligner.MIDDLE:
				num = num / 2;
				break;
				case Aligner.BOTTOM: // also BACK
				num = num;
				break;
				case Aligner.LEFT:
				num = 0;
				break;
				case Aligner.RIGHT:
				num = num;
				break;
				case Aligner.FRONT:
				num = 0;
				break;
				default: //  CENTER
				num = num / 2;
				break;
			}
			return num;
		}
		
		/**
		 * Provide a height, width and depth of the cube and a location string 
		 * to return a point with the cube (still untested at this time).
		 * 
		 * @param w			The width of the area you'd like the position in.
		 * @param h			The height of the area you'd like the position in.
		 * @param d			The depth of the area you'd like the position in.
		 * @param position	String representing the postioning, T, M, B, L, C, R, F, B and combinations of 3 are allowed.
		 * @return 			Point object with the x and y locations of the alignment.
		 */
		public static function getPosition3D(w:Number=0, h:Number=0, d:Number = 0, position:String="MCC"):Object
		{
			var p:Point = getPosition(w, h, position.substr(0,2));
			var o:Object = {x:p.x, y:p.y, z:0};
			
			if(d > 0)
				o.z = parsePosition(d, position.substr(2,1));
			
			return o;
		}
	}
}