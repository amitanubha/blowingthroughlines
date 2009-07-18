package com.paperclipped.physics
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;

	public class Body
	{
		public static const CIRCLE:String = "circle";
		public static const POLYGON:String = "polygon";
		public static const SQUARE:String = "square";
		public static const TRIANGLE:String = "triangle";
		
		private var _body:b2Body;
		private var _scale:Number;
		private var _world:b2World;
		
		public function get body():b2Body	{ return _body;	}
		
		public function Body(world:World, x:int, y:int, shape:String="square", w:Number, h:Number, vertices:Array=null)
		{
			_scale = world.scale;
			_world = world.world;
			
			switch(shape)
			{
				case Body.CIRCLE:
				createCircle(x,y,w);
				break;
				
				case Body.SQUARE:
				createSquare(x,y,w,h);
				break;
				
				case Body.TRIANGLE:
				createTriagle(x,y,vertices);
				break;
				
				default: // POLYGON
				createTriagle(x,y,vertices);
				break;
			}
		}
	}
}