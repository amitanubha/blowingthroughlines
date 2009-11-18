package com.paperclipped.geom
{
	import flash.geom.Point;
	
	public class Trig
	{
		public function Trig()
		{
			throw new Error("this is a static class right now, don't instanciate it!");
		}
		
		/**
		 * Returns an array of points arranged in a circle.
		 * 
		 * @param radius 	The radius of the circle of points.
		 * @param count 	Then number of points around the circle.
		 * @return 			Array of Points
		 */		
		public static function PointsInACircle(radius:Number, count:int):Array
		{
			var theta:Number = (360 / count) * (Math.PI / 180);
			var points:Array = new Array();
			
			for(var i:int = 0; i < count; i++)
			{
				var point:Point = new Point();
				point.x = radius * Math.cos(theta * i);
				point.y = radius * Math.sin(theta * i);
				points.push(point);
			}
			
			return points;
		}
		
		public static class getAngle(point1:Point, point2:Point)
		{
			var p:Point = new Point(0,0);
//			p.
		}
	}
}