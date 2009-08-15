package com.paperclipped.physics
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;

	public class Wall
	{
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		
		private var _body:b2Body;
		
		public function get body():b2Body	{ return _body;	}
		
		public function Wall(world:World, side:String, offset:Number=5, friction:Number=0.3)
		{
			// create walls
			var wallSd:b2PolygonDef = new b2PolygonDef();
			wallSd.friction = friction;
			var wallBd:b2BodyDef = new b2BodyDef();

			

			switch(side)
			{
				case Wall.LEFT:// Left
					wallBd.position.Set(-(offset-50 / world.scale), (world.height+100) / world.scale / 2);
					wallSd.SetAsBox(100 / world.scale, (world.height+100) / world.scale/2);
					_body = world.world.CreateBody(wallBd);
					_body.CreateShape(wallSd);
					_body.SetMassFromShapes();
				break;
				
				case Wall.RIGHT:// Right
					wallBd.position.Set((world.width+offset+100) / world.scale, (world.height+100) / world.scale / 2);
					wallSd.SetAsBox(100 / world.scale, (world.height+100) / world.scale/2);
					_body = world.world.CreateBody(wallBd);
					_body.CreateShape(wallSd);
					_body.SetMassFromShapes();
				break;
				
				case Wall.TOP:// Top
					wallBd.position.Set(world.width / world.scale / 2, -(offset+100 / world.scale));
					wallSd.SetAsBox((world.width + 100) / world.scale / 2, 100 / world.scale);
					_body = world.world.CreateBody(wallBd);
					_body.CreateShape(wallSd);
					_body.SetMassFromShapes();
				break;
				
				case Wall.BOTTOM:// Bottom
					wallBd.position.Set(world.width / world.scale / 2, (world.height+offset+100) / world.scale);
					wallSd.SetAsBox((world.width + 100) / world.scale / 2, 100 / world.scale);
					_body = world.world.CreateBody(wallBd);
					_body.CreateShape(wallSd);
					_body.SetMassFromShapes();
				break;
			}
			
			trace("created wall", side, world.world, world.scale, world.height, world.width);
		}
	}
}