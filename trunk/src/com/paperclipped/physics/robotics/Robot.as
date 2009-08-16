package com.paperclipped.physics.robotics
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.b2Body;
	
	import com.paperclipped.physics.Body;
	import com.paperclipped.physics.Joint;
	import com.paperclipped.physics.World;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class Robot extends Sprite
	{
//		public static const SQUARE:String 	= "square";
//		public static const CIRCLE:String 	= "circle";
//		public static const TRIANGLE:String = "triangle";
//		public static const POLYGON:String	= "polygon";

		public var motors:Array;
		public var body:b2Body;
		
		private var _myWorld:World;
		private var _scale:Number;
		private var _group:int;
		private var _spiderMotors:Array = new Array();
		private var _step:int = 0;
		private var _wheel:Body
		
		public function get group():int 	{ return _group;	}
		
		public function Robot(world:World, x:int, y:int, group:int = -1)
		{
			_group = (group > 0)? -group:group;
			_myWorld = world;
			
			init();
		}
		
		private function init():void
		{
//			var mondoBody:Body = Body.staticBody(_myWorld, 300, 200, 200, 100, Body.RECTANGLE, null, -6);
			var mondoBody:Body = new Body(_myWorld, 300, 400, 100, 60, Body.RECTANGLE, null, -6);
//			var mondoBody:Body = new Body(_myWorld, 150, 400, 200, 100, Body.RECTANGLE, null, -6, 0, true, 0.3, 0.1, 1);
			
			_wheel = createMotor(mondoBody, 0, 14, -90);

			createMondoLeg(mondoBody, 2, 0, 14, "left");
			createMondoLeg(mondoBody, 2, 0, 14, "right");
			
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function createMotor(parent:Body, x:int=0, y:int=0, speed:int=-90):Body
		{
			var loc:b2Vec2 = parent.body.GetPosition().Copy(); //!!! Really????
			loc.Multiply(_myWorld.scale);
			loc.x += x;
			loc.y += y;
			
			var grp:int = parent.group;
			
			var wheelDiameter:int = 52;
			
			var wheel:Body = new Body(_myWorld, loc.x, 		loc.y, 		wheelDiameter,0, 	Body.CIRCLE, 	null, grp);
//			var parent2Wheel:Joint = new Joint(_myWorld, parent.body, wheel.body, new b2Vec2(x,y), new b2Vec2(0,0), Joint.HINGE, true, -60);
			_spiderMotors.push(new Joint(_myWorld, parent.body, wheel.body, new b2Vec2(x,y), new b2Vec2(0,0), Joint.HINGE, true, speed));
			return wheel;
		}
		
		private function createMondoLeg(parent:Body, legCount:int=1, x:int=0, y:int=0, direction:String="left"):void
		{
			var dir:int = (direction == "left") ? 1 : -1;
			trace("creating mondo leg");
			
			var loc:b2Vec2 = parent.body.GetPosition().Copy(); //!!! Really????
			loc.Multiply(_myWorld.scale);
			loc.x += x;
			loc.y += y;
			
			var grp:int = parent.group;
			
			var wheelDiameter:int = 52;
			var wheel:Body = new Body(_myWorld, loc.x, 		loc.y, 		wheelDiameter,0, 	Body.CIRCLE, 	null, grp);
//			var parent2Wheel:Joint = new Joint(_myWorld, parent.body, wheel.body, new b2Vec2(x,y), new b2Vec2(0,0), Joint.HINGE, true, -60);
			_spiderMotors.push(new Joint(_myWorld, parent.body, wheel.body, new b2Vec2(x,y), new b2Vec2(0,0), Joint.HINGE, true, -90));
			
			var theta:Number 		= (360 / legCount)*(Math.PI/180);
			var wheelLoc:b2Vec2 	= new b2Vec2();
			var ankleLength:Number 	= 32; //29.07;
			var shinLength:Number 	= 63.66;
			
			
			var footVerts:Array = new Array( 	
												new b2Vec2( 48.5  * dir, -95.5), // Top
												new b2Vec2(-8.5 * dir,   -27.5), // Middle
												new b2Vec2(-7.5 * dir,    95.5)  // Bottom
												);
													
			if(dir == 1) footVerts = footVerts.reverse();
//			var foot2ThighVert:int = (dir == 1)? 1 : 
			var shin2FootVert:int = (dir == 1) ? 2 : 0;
						
			var thighX:Number 	= -50 * dir;
			var footX:Number 	= -71.5 * dir; // TODO: this too!
			
			var thigh2WheelAxis:b2Vec2 	= new b2Vec2( 51 * dir, -6);
			var thigh2FootAxis:b2Vec2 	= new b2Vec2(-50 * dir,  6);
			
			var ankle2ParentAxis:b2Vec2 = new b2Vec2(x+(-46 * dir), y+14);
			var shin2ParentAxis:b2Vec2	= new b2Vec2(x+(-3* dir), 	y-38);
			var ankle2ThighAxis:b2Vec2	= new b2Vec2(5 * dir, 5);
			
			var foot2ThighAxis:b2Vec2 	= b2Vec2(footVerts[1]).Copy();
			var shin2FootAxis:b2Vec2	= b2Vec2(footVerts[shin2FootVert]).Copy(); //b2Vec2(footVerts[2]).Copy(); //new b2Vec2(-28.5 * dir, 95.5);

			
			for(var i:int=0; i < legCount; i++)
			{
				var thigh:Body = new Body(_myWorld, loc.x+thighX, 	loc.y-20, 	100, 	16, 		Body.RECTANGLE, null, 		grp);
				
				var foot:Body  = new Body(_myWorld, loc.x+footX, 	loc.y-10,	 57, 	191, 		Body.TRIANGLE, 	footVerts, 	grp);
				
					wheelLoc.x = (wheelDiameter/2) * Math.cos(theta * (i+1));
					wheelLoc.y = (wheelDiameter/2) * Math.sin(theta * (i+1));
				
				var wheel2Thigh:Joint 	= new Joint(_myWorld, wheel.body, thigh.body, 	wheelLoc, 			thigh2WheelAxis);
				var thigh2Foot:Joint 	= new Joint(_myWorld, thigh.body, foot.body, 	thigh2FootAxis, 	foot2ThighAxis);
				
//				var ankle:Body = new Body(_myWorld, loc.x-46, 	loc.y, 		10, 	30, 		Body.RECTANGLE, null, grp); //TODO: Switch to distance joint?
//				var ankle2Parent:Joint 	= new Joint(_myWorld, ankle.body, parent.body, 	new b2Vec2(0, 14), 	new b2Vec2(x+46, y-14));
//				var ankle2Thigh:Joint 	= new Joint(_myWorld, ankle.body, thigh.body, 	new b2Vec2(0, -15), new b2Vec2(-5,-5));
				
				// temp distance joints to speed things up.
				var ankle:Joint = new Joint(_myWorld, parent.body, thigh.body, ankle2ParentAxis, ankle2ThighAxis, Joint.ARM, false, 0, 0, ankleLength);
				var shin:Joint = new Joint(_myWorld, parent.body, foot.body, shin2ParentAxis, shin2FootAxis, Joint.ARM, false, 0, 0, shinLength);
			}
		}
		// showThumb(image);
		// showFull(image);
		
		private function update(evt:Event):void
		{
			if(_step == 500)
			{
				for( var k:int=0; k < _spiderMotors.length; k++)
				{
					var joint:b2RevoluteJoint = b2RevoluteJoint(_spiderMotors[k].joint);
					
					var speed:Number = joint.GetMotorSpeed();
					joint.SetMotorSpeed(speed * -1);
				}
				_step = 0;
				trace("reversing motors!");
			}
			
			_step ++;
		}
	}
}