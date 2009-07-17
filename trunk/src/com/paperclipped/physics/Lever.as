package com.paperclipped.physics
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;

	/**
	 * This is a container class to make the creation of a chain simpler
	 * Box2D r47 or greater required.
	 * (c) 2009 Collin Reisdorf MIT License
	 * 
	 * @author Collin Reisodrf
	 */	
	public class Chain extends Sprite
	{
//-----------------------------------------Variables-----------------------------------------//
//		public static const HORIZONTAL:String = 'h';
//		public static const VERTICAL:String = 'v'; // not supported yet
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		
//		private var _anchor:b2Vec2;
		private var _bodies:Array;
		private var _joints:Array;
//		private var _parent:
		private var _world:b2World;
//-------------------------------------------------------------------------------------------//
		
//------------------------------------------Getters------------------------------------------//
//		public function get anchor():b2Vec2	{ return _anchor;								}
		public function get bodies():Array 	{ return _bodies;								}
		public function get end():b2Body 	{ return _bodies[_bodies.length-1] as b2Body;	}
		public function get joints():Array	{ return _joints;								}
		public function get start():b2Body	{ return _bodies[0] as b2Body;					}
//-------------------------------------------------------------------------------------------//

//------------------------------------------Setters------------------------------------------//
//-------------------------------------------------------------------------------------------//

//----------------------------------------Constructor----------------------------------------//
		public function Chain(world:b2World, numLinks:uint=3, anchorX:int=0, anchorY:int=0, link:b2PolygonDef=null, linkLength:Number=44, direction:String=null, swingLimit:uint=0, parent:b2Body=null, scale:uint=30)
		{
			this.mouseEnabled = false;

			_bodies = new Array();
			_joints = new Array();
			_world = world;

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
			for (i = 0; i < numLinks; ++i)
			{
			
				switch(direction)
				{
					case Chain.RIGHT:
					bd.position.Set((anchorX + (linkLength / 2) + linkLength * i) / scale, anchorY / scale);
					anchor.Set((anchorX + linkLength * i) / scale, anchorY / scale);
					break;
					
					case Chain.LEFT:
					bd.position.Set((anchorX - (linkLength / 2 ) - linkLength * i) / scale, anchorY / scale);
					anchor.Set((anchorX - linkLength * i) / scale, anchorY / scale);
					break;
					
					case Chain.UP:
					bd.position.Set(anchorX / scale, (anchorY - (linkLength / 2) - linkLength * i) / scale);
					bd.angle = -90 / (180/Math.PI);
					anchor.Set(anchorX / scale, (anchorY - linkLength * i) / scale);
					break;
					
					default: // down
					bd.position.Set(anchorX / scale, (anchorY + (linkLength / 2) + linkLength * i) / scale);
					bd.angle = 90 / (180/Math.PI);
					anchor.Set(anchorX / scale, (anchorY + linkLength * i) / scale);
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
		public function destroy():void
		{
			if(this.graphics) this.graphics.clear();
			for each(var body:b2Body in _bodies)
			{
//				_world.DestroyJoint(body.GetJointList().joint);
				_world.DestroyBody(body);
			}
		}
//-------------------------------------------------------------------------------------------//
	}
}