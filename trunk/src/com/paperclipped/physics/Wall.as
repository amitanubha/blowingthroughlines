package com.paperclipped.physics
{
	import Box2D.Dynamics.b2Body;

	public class Wall
	{
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		
//		private var _body:b2Body;
		private var _wall:Body;
		
		public function get body():b2Body	{ return _wall.body;	}
		
		public function Wall(world:World, side:String, offset:Number=5, friction:Number=0.6, group:int = 0)
		{
			switch(side)
			{
				case Wall.LEFT:// Left
//					wallBd.position.Set(-(offset-50 / world.scale), (world.height+100) / world.scale / 2);
//					wallSd.SetAsBox(100 / world.scale, (world.height+100) / world.scale/2);
//					_body = world.world.CreateBody(wallBd);
//					_body.CreateShape(wallSd);
//					_body.SetMassFromShapes();

					_wall = Body.staticBody(world, 0 - (50-offset), world.height / 2, 100, world.height + 100, Body.RECTANGLE);
					
				break;
				
				case Wall.RIGHT:// Right
//					wallBd.position.Set((world.width+offset+100) / world.scale, (world.height+100) / world.scale / 2);
//					wallSd.SetAsBox(100 / world.scale, (world.height+100) / world.scale/2);
//					_body = world.world.CreateBody(wallBd);
//					_body.CreateShape(wallSd);
//					_body.SetMassFromShapes();

					_wall = Body.staticBody(world, world.width + (50-offset), world.height / 2, 100, world.height + 100, Body.RECTANGLE);
				break;
				
				case Wall.TOP:// Top
//					wallBd.position.Set(world.width / world.scale / 2, -(offset-50 / world.scale));
//					wallSd.SetAsBox((world.width + 100) / world.scale / 2, 100 / world.scale);
//					_body = world.world.CreateBody(wallBd);
//					_body.CreateShape(wallSd);
//					_body.SetMassFromShapes();

					_wall = Body.staticBody(world, world.width / 2, 0 - (50-offset), world.width + 100, 100, Body.RECTANGLE);
				break;
				
				case Wall.BOTTOM:// Bottom
//					wallBd.position.Set(world.width / world.scale / 2, (world.height+offset+100) / world.scale);
//					wallSd.SetAsBox((world.width + 100) / world.scale / 2, 100 / world.scale);
//					_body = world.world.CreateBody(wallBd);
//					_body.CreateShape(wallSd);
//					_body.SetMassFromShapes();

					_wall = Body.staticBody(world, world.width / 2, world.height + (50-offset), world.width + 100, 100, Body.RECTANGLE);
				break;
			}
			
			trace("created wall", side, world.world, world.scale, world.height, world.width);
		}
	}
}