package com.paperclipped.physics
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;

	/**
	 * This is a container class to make the creation of a chain simpler
	 * Box2D r47 or greater required.
	 * (c) 2009 Collin Reisdorf MIT License
	 * 
	 * @author Collin Reisodrf
	 */	
	public class Chain
	{
//-----------------------------------------Variables-----------------------------------------//
//		public static const HORIZONTAL:String = 'h';
//		public static const VERTICAL:String = 'v'; // not supported yet
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		
		private var _bodies:Array;
		private var _joints:Array;
//		private var _parent:
		private var _world:b2World;
//-------------------------------------------------------------------------------------------//
		
//------------------------------------------Getters------------------------------------------//
		public function get bodies():Array 	{ return _bodies;								}
		public function get end():b2Body 	{ return _bodies[_bodies.length-1] as b2Body;	}
		public function get joints():Array	{ return _joints;								}
		public function get start():b2Body	{ return _bodies[0] as b2Body;					}
//-------------------------------------------------------------------------------------------//

//------------------------------------------Setters------------------------------------------//
//-------------------------------------------------------------------------------------------//

//----------------------------------------Constructor----------------------------------------//
		public function Chain(world:b2World, numLinks:uint=3, anchorX:int=0, anchorY:int=0, link:b2PolygonDef=null, direction:String=null, swingLimit:uint=0, parent:b2Body=null, scale:uint=30)
		{
			_world = world;
			_bodies = new Array();
			_joints = new Array();
//			_parent = parent; // not sure what/how to attach this to yet...
			
//			var ground:b2Body = world.GetGroundBody();
			var i:int;
			var anchor:b2Vec2 = new b2Vec2();
			var body:b2Body;
			var joint:b2Joint;
			
			if(!link)
			{
				link = new b2PolygonDef();
				link.SetAsBox(24 / scale, 5 / scale);
				link.density = 100.0;
				link.friction = 0.8;
			}
			
			var bd:b2BodyDef = new b2BodyDef();
			
			var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
			if(swingLimit > 0)
			{
				jd.lowerAngle = -swingLimit / (180/Math.PI);
				jd.upperAngle = swingLimit / (180/Math.PI);
				jd.enableLimit = true;
			}else
			{
				jd.enableLimit = false;
			}
			
			var prevBody:b2Body = (parent)? parent:world.GetGroundBody();
			for (i = 0; i < 3; ++i)
			{
				switch(direction)
				{
					case Chain.RIGHT:
					bd.position.Set((anchorX + 22 + 44 * i) / scale, anchorY / scale);
					anchor.Set((anchorX + 44 * i) / scale, anchorY / scale);
					break;
					
					case Chain.LEFT:
					bd.position.Set((anchorX - 22 - 44 * i) / scale, anchorY / scale);
					anchor.Set((anchorX - 44 * i) / scale, anchorY / scale);
					break;
					
					case Chain.UP:
					bd.position.Set(anchorX / scale, (anchorY - 22 - 44 * i) / scale);
					bd.angle = -90 / (180/Math.PI);
					anchor.Set(anchorX / scale, (anchorY - 44 * i) / scale);
					break;
					
					default: // down
					bd.position.Set(anchorX / scale, (anchorY + 22 + 44 * i) / scale);
					bd.angle = 90 / (180/Math.PI);
					anchor.Set(anchorX / scale, (anchorY + 44 * i) / scale);
					break;
				}

				body = world.CreateBody(bd);
				body.CreateShape(link);
				body.SetMassFromShapes();
				
				jd.Initialize(prevBody, body, anchor);
				joint = world.CreateJoint(jd);
				
				prevBody = body;
				_bodies.push(body);
				_joints.push(joint);
			}
		}
//-------------------------------------------------------------------------------------------//

//--------------------------------------Private Methods--------------------------------------//
//-------------------------------------------------------------------------------------------//

//--------------------------------------Public  Methods--------------------------------------//
//-------------------------------------------------------------------------------------------//
	}
}