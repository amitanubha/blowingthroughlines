package com.paperclipped.geom
{
	import flash.display.Shape;
	import flash.geom.Point;
	
	/**
	 *	This is a completely untested class, and much of it is still in progress.
	 *	<p>The angle method, for instance, only returns 90!</p>
	 *	
	 *	@copyright Collin Reisdorf 2008
	 */
	public class Triangle extends Shape
	{
		private var _a:Point;
		private var _b:Point;
		private var _c:Point;
		
		// ------------------------- getters ------------------------------
		public function get angleA():Number {	return angle(_a, _b, _c);	}
		public function get angleB():Number {	return angle(_b, _a, _c);	}
		public function get angleC():Number {	return angle(_c, _a, _b);	}
		
		public function get sideAB():Number	{	return sideLength(_a, _b);	}
		public function get sideBC():Number	{	return sideLength(_b, _c);	}
		public function get sideCA():Number	{	return sideLength(_c, _a);	}	
		
		public function get area():Number
		{
			var mult:Number = (sideAB + sideBC + sideCA) / 2
			return Math.sqrt(mult * (mult - sideAB) * (mult - sideBC) * (mult - sideCA));
		}
		
		public function get type():String
		{
			// if(is a right triangle)
			{
				return "right";
			}else if(sideAB == sideBC && sideBC == sideCA)
			{
				return "equalateral";
			}else if(sideAB == sideBC || sideBC == sideCA)
			{
				return "isoceles";
			}else 
			{
				// do something to determine if it's
				return "scalene";
			}
		}
		
		/**
		 *	Not sure how useful this could be, but if a side is horizontal, it is call the base.
		 *	Right now the base can be on top, as long as it's horizonal. Not sure if that should
		 *	change, because the only consequence is that the altitude can be negative...
		 *	
		 *	@return The 2 vertices of the base.
		 */
		public function get base():Array
		{
			if(_a.y == _b.y)
			{
				return [_a, _b];
			}else if(_a.y == _c.y)
			{
				return [_a, _c];
			}else if(_b.y == _c.y)
			{
				return [_b, _c];
			}else
			{
				return null;
			}
		}
		
		/**
		 *	Again altitude probably isn't that useful, but if there is a base to the Triangle, then
		 *	the value of the distance between the base and the opposite vertex will be returned
		 *	
		 *	@return The distance from the base to the opposite vertex (can be negative currently).
		 */
		public function get altitude():Number
		{
			if(this.base)
			{
				if(this.base[0].y < _a.y)
				{
					return _a.y - this.base[0].y;
				}else if(this.base[0].y < _b.y)
				{
					return _b.y - this.base[0].y;
				}else if(this.base[0].y < _c.y)
				{
					return _c.y - this.base[0].y;
				}else if
				{
					return 0;
				}
				/*return Math.abs((_a.y - _b.y) - (_a.y - _c.y) )*/
			}else
			{
				return 0;
			}
		}
		
		// ------------------------- setters ------------------------------
		
		
		// ------------------------- methods ------------------------------
		public function Triangle(a:Point, b:Point, c:Point):void
		{
			// make a new triangle
			_a = a;
			_b = b;
			_c = c;
			
			init();
		}
		
		private function init():void
		{
			// dunno yet
		}
		
		private function drawTriangle(lineColor:Number=0x0, lineThickness=1, lineAlpha:Number=1, fillColor:Number=0xFFFFFF, fillAlpha:Number=1, fillBmp:Bitmap=null):void
		{
			this.lineStyle(lineColor, lineThickness, lineAlpha);
			if(fillBmp)
			{
				this.graphics.beginBitmapFill(fillBmp, fillAlpha);
			}else
			{
				this.graphics.beginFill(fillColor, fillAlpha);
			}
			this.graphics.moveTo(_a.x, _a.y);
			this.graphics.lineTo(_b.x, _b,y);
			this.graphics.lineTo(_c.x, _c.y);
			this.graphics.lineTo(_a.x, _a.y);
			this.graphics.endFill();
		}
		
		/**
		 *	@return The length of a side for the given vertices.
		 */
		public function sideLength(vertA:Point, vertB:Point):Number
		{
			return Point.distance(vertA, vertB);
		}
		
		/**
		 *	@return The angle of a vertex given the opposing vertices or lengths.
		 */
		public function angle(a:*, vertex:Point, b:*):Number
		{
			if(a is Point) //...
			if(b is Number) //we assume it's an angle and do angle angle angle... i think, i don't remember.
			
			// claculate angle
			
			return 90;
		}
	}
}