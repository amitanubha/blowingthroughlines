package com.paperclipped.physics.robotics
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.b2Body;
	
	import com.paperclipped.physics.Body;
	import com.paperclipped.physics.Joint;
	import com.paperclipped.physics.World;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
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
		private var _chassis:Body;
		private var _spiderMotors:Array = new Array();
//		private var _shin:Joint; // unsused
		private var _step:int = 0;
		private var _wheel:Body;
		
		// Klann Parameters
		private var _lowerRockerAxis:b2Vec2;
		private var _lowerRocker:Number;
		private var _footTopAxis:b2Vec2;	// where the shin attaches
		private var _footMidAxis:b2Vec2; // the "knee" joint
		private var _footBtmAxis:b2Vec2; // where the foot touches the ground
		private var _upperRocker:Number;
		private var _upperRockerAxis:b2Vec2;
		private var _cRodLength:Number;
		private var _cRodHeight:Number;
		private var _cRodCenter:Number;
		private var _wheelAxis:b2Vec2;
		private var _wheelRadius:Number;
		private var _speed:int;
		
		// debugging
		private var _feetLines:Bitmap;
		private var _legJoints:Array;
		private var _legBodies:Array;
		
		public function get group():int 	{ return _group;	}
		
		public function Robot(world:World, x:int, y:int, group:int = -1, fixed:Boolean=false)
		{
			_group = (group > 0)? -group:group;
			_myWorld = world;
			_legBodies = new Array();
			_legJoints = new Array();
			
			// Setting the Klann params // with old values...
			_lowerRockerAxis= new b2Vec2(-70,50); //new b2Vec2(-93, 16); // -50,20
			_lowerRocker 	= 56; //36; // 32 // shorter is more concave, longer is closer to what i want
//			_footTopAxis 	= new b2Vec2(54.5,-66); //new b2Vec2(54.5, -66); // 47,-68
			_footMidAxis 	= new b2Vec2(-10,20); //new b2Vec2(-10, 0); // -10,0
//			_footBtmAxis 	= new b2Vec2(-10,90); //new b2Vec2(-10, 114); // -10,123
//			_upperRocker 	= 60; //76.58; // 63.66
//			_upperRockerAxis= new b2Vec2(-45,-25); //new b2Vec2(-31, -36); // -3, -38
			_cRodLength 	= 150; //154; // 110
			_cRodHeight 	= 20; //20; // 12
//			_wheelAxis		= new b2Vec2(0, -10);
			_cRodCenter 	= -5; //14; // 5
//			_wheelRadius 	= 28; //31; // 24


			_footTopAxis 	= new b2Vec2(40,-50);
			_footBtmAxis 	= new b2Vec2(0,120);
			_upperRocker 	= 55;
			_upperRockerAxis= new b2Vec2(-70,-10);
			_wheelAxis		= new b2Vec2(0, -5); // not sure this does much...
			_wheelRadius 	= 35; //31; // 24
			
			_speed			= -60;
			_scale			= 1;

//			_lowerRockerAxis = new b2Vec2(-60,50); //new b2Vec2(-93, 16); // -50,20
//			_lowerRocker 	= 60; //36; // 32
//			_footTopAxis 	= new b2Vec2(54.5,-66); //new b2Vec2(54.5, -66); // 47,-68
//			_footMidAxis 	= new b2Vec2(-10,0); //new b2Vec2(-10, 0); // -10,0
//			_footBtmAxis 	= new b2Vec2(-10,114); //new b2Vec2(-10, 114); // -10,123
//			_upperRocker 	= 76.58; //76.58; // 63.66
//			_upperRockerAxis= new b2Vec2(-31,-36)//new b2Vec2(-31, -36); // -3, -38
//			_thighLength 	= 153.5; //154; // 110
//			_thighHeight 	= 20; //20; // 12
//			_thighCenter 	= 14; //14; // 5
//			_wheelRadius 	= 31; //31; // 24
//			_speed			= -90;

//			_lowerRockerAxis= new b2Vec2(-50,20);
//			_lowerRocker 	= 36;
//			_footTopAxis 	= new b2Vec2(47,-68);
//			_footMidAxis 	= new b2Vec2(-10,0);
//			_footBtmAxis 	= new b2Vec2(-10,123);
//			_upperRocker 	= 63.66;
//			_upperRockerAxis= new b2Vec2(-3,-38);
//			_thighLength 	= 110
//			_thighHeight 	= 12
//			_thighCenter 	= 5;
//			_wheelRadius 	= 24
//			_speed			= -90;

//			_lowerRockerAxis= new b2Vec2(-65,30); //new b2Vec2(-93, 16); // -50,20
//			_lowerRocker 	= 40; //36; // 32
//			_footTopAxis 	= new b2Vec2(60,-68); //new b2Vec2(54.5, -66); // 47,-68
//			_footMidAxis 	= new b2Vec2(-10,0); //new b2Vec2(-10, 0); // -10,0
//			_footBtmAxis 	= new b2Vec2(-10,120); //new b2Vec2(-10, 114); // -10,123
//			_upperRocker 	= 92; //76.58; // 63.66
//			_upperRockerAxis= new b2Vec2(-18,-38)//new b2Vec2(-31, -36); // -3, -38
//			_thighLength 	= 150; //154; // 110
//			_thighHeight 	= 12; //20; // 12
//			_thighCenter 	= 15; //14; // 5
//			_wheelRadius 	= 24; //31; // 24
//			_speed			= -90;
			
			init(x,y,fixed);
		}
		
		public function init(x:int, y:int, fixed:Boolean):void
		{
			_chassis = (!fixed) ? new Body(_myWorld, x, y, 160, 80, Body.RECTANGLE, null, _group) : Body.staticBody(_myWorld, x, y, 200, 100, Body.RECTANGLE, null, -6);
			
			_wheel = createMotor(_chassis, 0, 10, _speed);

			createMondoLeg(_chassis, 2, 0, 10, "left"); //FIXME: Something isn't being moved in the Y direction when the value is modified.
			createMondoLeg(_chassis, 2, 0, 10, "right");
			
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function createMotor(parent:Body, x:int=0, y:int=0, speed:int=-90):Body
		{
			var loc:b2Vec2 = parent.body.GetPosition().Copy();
			loc.Multiply(_myWorld.scale);
			loc.x += x;
			loc.y += y;
			
			loc.Multiply(_scale);
			
			var wheelAxis:b2Vec2 = new b2Vec2(_wheelAxis.x + x, _wheelAxis.y + y);  
			
			var wheel:Body = new Body(_myWorld, loc.x, loc.y, _wheelRadius * 2 * _scale, 0, Body.CIRCLE, null, _group);
			_spiderMotors.push(new Joint(_myWorld, parent.body, wheel.body, wheelAxis, new b2Vec2(0,0), Joint.HINGE, true, speed, 100000000));
			return wheel;
		}
		
		private function createMondoLeg(parent:Body, legCount:int=1, x:int=0, y:int=0, direction:String="left"):void
		{
			var dir:int = (direction == "left") ? 1 : -1;
			dir *= _scale;
			
			var loc:b2Vec2 = parent.body.GetPosition().Copy(); //!!! Really????
			loc.Multiply(_myWorld.scale);
			loc.x += x;
			loc.y += y;
			
			var footVerts:Array = new Array( 	
												new b2Vec2(_footTopAxis.x * dir, _footTopAxis.y * _scale), // Top
												new b2Vec2(_footMidAxis.x * dir, _footMidAxis.y * _scale), // Middle
												new b2Vec2(_footBtmAxis.x * dir, _footBtmAxis.y * _scale)  // Bottom
												);
													
			if(dir == 1) footVerts = footVerts.reverse();
			var shin2FootVert:int = 1 + dir; //(dir == 1) ? 2 : 0;
						
			var thighX:Number 	= -50 * dir + loc.x; // TODO: this should be located by the x, and y 
			var thighY:Number	= (loc.y-80) * _scale;
			var footX:Number 	= -71.5 * dir + loc.x; // TODO: this too!
			var footY:Number	= (loc.y-80) * _scale; // FIXME: bletcherous hack
			
			var thigh2WheelAxis:b2Vec2 	= new b2Vec2((_cRodLength/2)  * dir, 	-_cRodHeight/2 * _scale);
			var thigh2FootAxis:b2Vec2 	= new b2Vec2((_cRodLength/-2) * dir,  	_cRodHeight/2 * _scale);
			
			var ankle2ThighAxis:b2Vec2	= new b2Vec2(_cRodCenter * dir, 		_cRodHeight/2 * _scale);
			var ankle2ParentAxis:b2Vec2 = new b2Vec2(x+(_lowerRockerAxis.x * dir), 	y+_lowerRockerAxis.y * _scale);
			var shin2ParentAxis:b2Vec2	= new b2Vec2(x+(_upperRockerAxis.x  * dir), 	y+_upperRockerAxis.y * _scale);
			
			var foot2ThighAxis:b2Vec2 	= b2Vec2(footVerts[1]).Copy();
//			foot2ThighAxis.y += 15; // FIXME: hack alert, but makes the legs not move in the wrong direction...
			var shin2FootAxis:b2Vec2	= b2Vec2(footVerts[shin2FootVert]).Copy(); //b2Vec2(footVerts[2]).Copy(); //new b2Vec2(-28.5 * dir, 95.5);

			var theta:Number 		= (360 / legCount)*(Math.PI/180);
			var wheel2CRodAxis:b2Vec2 	= new b2Vec2();
			
			for(var i:int=0; i < legCount; i++)
			{
				var connectingRod:Body = new Body(_myWorld, thighX, thighY, 	_cRodLength, 	_cRodHeight, 		Body.RECTANGLE, null,						_group);			
				var foot:Body  = new Body(_myWorld, footX, 	footY,	 	1, 				1, 					Body.TRIANGLE, 	footVerts, _group, 0, true, 1, 0.1, 1.0, false, 0, 0, footDebugger(footVerts[Math.abs(shin2FootVert - 2)]));
				
					wheel2CRodAxis.x = (_wheelRadius * _scale) * Math.cos(theta * (i+1));
					wheel2CRodAxis.y = (_wheelRadius * _scale) * Math.sin(theta * (i+1));
				
				var wheel2CRod:Joint 	= new Joint(_myWorld, _wheel.body, 	connectingRod.body,	wheel2CRodAxis, 	thigh2WheelAxis);
				var cRod2Foot:Joint 	= new Joint(_myWorld, connectingRod.body, 	foot.body, 	thigh2FootAxis, 	foot2ThighAxis);
				
				// temp distance joints to speed things up. (Should do bodies later for adding graphics...)
				var ankle:Joint 	= new Joint(_myWorld, parent.body, connectingRod.body, 	ankle2ParentAxis, 	ankle2ThighAxis, 	Joint.ARM, false, 0, 0, _lowerRocker * _scale);
//				if(!_shin) _shin 	= new Joint(_myWorld, parent.body, foot.body, 	shin2ParentAxis, 	shin2FootAxis, 		Joint.ARM, false, 0, 0, _upperRocker * _scale);
//				else var shin:Joint = new Joint(_myWorld, parent.body, foot.body, 	shin2ParentAxis, 	shin2FootAxis, 		Joint.ARM, false, 0, 0, _upperRocker * _scale);
				var shin:Joint = new Joint(_myWorld, parent.body, foot.body, 	shin2ParentAxis, 	shin2FootAxis, 		Joint.ARM, false, 0, 0, _upperRocker * _scale);
				_legBodies.push(connectingRod, foot);
				_legJoints.push(wheel2CRod, cRod2Foot, ankle, shin);
			}
		}
		
		private function footDebugger(loc:b2Vec2):Shape
		{
			var shape:Shape = new Shape();
				shape.graphics.beginFill(0xbada55);
				shape.graphics.drawCircle(loc.x+1, loc.y+1, 1);
				shape.graphics.endFill();
			this.addChild(shape);
			return shape;
		}
		// showThumb(image);
		// showFull(image);
		
		private function update(evt:Event):void
		{
//			var dj:b2DistanceJoint = b2DistanceJoint(_shin.joint); // dunno where i was going with this one.
			if(_step == 400)
			{
				for( var k:int=0; k < _spiderMotors.length; k++)
				{
					var joint:b2RevoluteJoint = b2RevoluteJoint(_spiderMotors[k].joint);
					
					var speed:Number = joint.GetMotorSpeed();
					joint.SetMotorSpeed(speed * -1);
				}
//				_step = -Math.abs(speed);
				_step = 0;
			}
			_step ++;
		}
//-------------------------------------------------------------------------------------------//

//--------------------------------------Public Methods---------------------------------------//
		public function destroyLegs():void
		{
			while(_legBodies.length > 0)
			{
				var body:Body = Body(_legBodies.slice(0,1)[0]);
				body.destroy();
			}
		}
//-------------------------------------------------------------------------------------------//
	}
}