package com.paperclipped.physics.robotics
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
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
		private var _shin:Joint;
		private var _step:int = 0;
		private var _wheel:Body;
		
		// Klann Parameters
		private var _ankleAxis:b2Vec2;
		private var _ankleLength:Number;
		private var _footTopAxis:b2Vec2;	// where the shin attaches
		private var _footMidAxis:b2Vec2; // the "knee" joint
		private var _footBtmAxis:b2Vec2; // where the foot touches the ground
		private var _shinLength:Number;
		private var _shinAxis:b2Vec2;
		private var _thighLength:Number;
		private var _thighHeight:Number;
		private var _thighCenter:Number;
		private var _wheelRadius:Number;
		
		private var _speed:int;
		
		
		public function get group():int 	{ return _group;	}
		
		public function Robot(world:World, x:int, y:int, group:int = -1)
		{
			_group = (group > 0)? -group:group;
			_myWorld = world;
			
			
			// Setting the Klann params // with old values...
			_ankleAxis		= new b2Vec2(-46,14); //new b2Vec2(-93, 16); // -46,14
			_ankleLength 	= 32; //36; // 32
			_footTopAxis 	= new b2Vec2(47,-68); //new b2Vec2(54.5, -66); // 48.5,-95.5
			_footMidAxis 	= new b2Vec2(-10,0); //new b2Vec2(-10, 0); // -8.5,-27.5
			_footBtmAxis 	= new b2Vec2(-10,123); //new b2Vec2(-10, 114); // -7.5, 95.5
			_shinLength 	= 63.66; //76.58; // 63.66
			_shinAxis 		= new b2Vec2(-3,-38)//new b2Vec2(-31, -36); // -3, -38
			_thighLength 	= 100; //154; // 100
			_thighHeight 	= 12; //20; // 12
			_thighCenter 	= 5; //14; // 5
			_wheelRadius 	= 26; //31; // 26
			_speed			= -90;
			
			init();
		}
		
		private function init():void
		{
			var mondoBody:Body = Body.staticBody(_myWorld, 300, 200, 200, 100, Body.RECTANGLE, null, -6);
//			var mondoBody:Body = new Body(_myWorld, 100, 400, 100, 60, Body.RECTANGLE, null, _group);
			
			_wheel = createMotor(mondoBody, 0, 14, _speed);

			createMondoLeg(mondoBody, 2, 0, 14, "left");
			createMondoLeg(mondoBody, 2, 0, 14, "right");
			
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function createMotor(parent:Body, x:int=0, y:int=0, speed:int=-90):Body
		{
			var loc:b2Vec2 = parent.body.GetPosition().Copy();
			loc.Multiply(_myWorld.scale);
			loc.x += x;
			loc.y += y;
			
			var wheel:Body = new Body(_myWorld, loc.x, loc.y, _wheelRadius * 2, 0, Body.CIRCLE, null, _group);
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
			
			var theta:Number 		= (360 / legCount)*(Math.PI/180);
			var wheel2ThighAxis:b2Vec2 	= new b2Vec2();
			
			
			var footVerts:Array = new Array( 	
												new b2Vec2(_footTopAxis.x * dir, _footTopAxis.y), // Top
												new b2Vec2(_footMidAxis.x * dir, _footMidAxis.y), // Middle
												new b2Vec2(_footBtmAxis.x * dir, _footBtmAxis.y)  // Bottom
												);
													
			if(dir == 1) footVerts = footVerts.reverse();
//			var foot2ThighVert:int = (dir == 1)? 1 : 
			var shin2FootVert:int = (dir == 1) ? 2 : 0;
						
			var thighX:Number 	= -50 * dir + loc.x; // TODO: this should be located by the x, and y 
			var footX:Number 	= -71.5 * dir + loc.x; // TODO: this too!
			
			var thigh2WheelAxis:b2Vec2 	= new b2Vec2((_thighLength/2)  * dir, 	-_thighHeight/2);
			var thigh2FootAxis:b2Vec2 	= new b2Vec2((_thighLength/-2) * dir,  	_thighHeight/2);
			var ankle2ThighAxis:b2Vec2	= new b2Vec2(_thighCenter * dir, 		_thighHeight/2);
			
			var ankle2ParentAxis:b2Vec2 = new b2Vec2(x+(_ankleAxis.x * dir), y+_ankleAxis.y);
			var shin2ParentAxis:b2Vec2	= new b2Vec2(x+(_shinAxis.x* dir), 	y+_shinAxis.y);
			
			var foot2ThighAxis:b2Vec2 	= b2Vec2(footVerts[1]).Copy();
			var shin2FootAxis:b2Vec2	= b2Vec2(footVerts[shin2FootVert]).Copy(); //b2Vec2(footVerts[2]).Copy(); //new b2Vec2(-28.5 * dir, 95.5);

			
			for(var i:int=0; i < legCount; i++)
			{
				var thigh:Body = new Body(_myWorld, thighX, loc.y, 	_thighLength, 	_thighHeight, 		Body.RECTANGLE, null, _group);
				var foot:Body  = new Body(_myWorld, footX, 	loc.y,	 	1, 				1, 					Body.TRIANGLE, 	footVerts, _group);
				
					wheel2ThighAxis.x = (_wheelRadius) * Math.cos(theta * (i+1));
					wheel2ThighAxis.y = (_wheelRadius) * Math.sin(theta * (i+1));
				
				var wheel2Thigh:Joint 	= new Joint(_myWorld, _wheel.body, 	thigh.body,	wheel2ThighAxis, 	thigh2WheelAxis);
				var thigh2Foot:Joint 	= new Joint(_myWorld, thigh.body, 	foot.body, 	thigh2FootAxis, 	foot2ThighAxis);
				
				// temp distance joints to speed things up. (Should do bodies later for adding graphics...)
				var ankle:Joint 	= new Joint(_myWorld, parent.body, thigh.body, 	ankle2ParentAxis, 	ankle2ThighAxis, 	Joint.ARM, false, 0, 0, _ankleLength);
				if(!_shin) _shin 	= new Joint(_myWorld, parent.body, foot.body, 	shin2ParentAxis, 	shin2FootAxis, 		Joint.ARM, false, 0, 0, _shinLength);
				else var shin:Joint = new Joint(_myWorld, parent.body, foot.body, 	shin2ParentAxis, 	shin2FootAxis, 		Joint.ARM, false, 0, 0, _shinLength);
			}
		}
		// showThumb(image);
		// showFull(image);
		
		private function update(evt:Event):void
		{
			
			var dj:b2DistanceJoint = b2DistanceJoint(_shin.joint);
			trace(dj.GetReactionForce(1).x);
			
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