package com.paperclipped.physics.robotics
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	
	import com.paperclipped.physics.World;

	public class Robot
	{
//		public static const SQUARE:String 	= "square";
//		public static const CIRCLE:String 	= "circle";
//		public static const TRIANGLE:String = "triangle";
//		public static const POLYGON:String	= "polygon";

		public var motors:Array;
		public var body:b2Body;
		
//		private var _myWorld:World;
		private var _scale:Number;
		private var _world:b2World;
		private var _group:int;
		
		public function get group():int 	{ return _group;	}
		
		public function Robot(world:World, x:int, y:int, group:int = -1)
		{
			_group = (group > -1)? -group:group;
			_scale = world.scale;
			_world = world.world;
		}
		
		// leg adder
		// showThumb(image);
		// showFull(image);
	}
}