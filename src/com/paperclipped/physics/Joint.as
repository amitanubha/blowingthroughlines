package com.paperclipped.physics
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2GearJointDef;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointDef;
	import Box2D.Dynamics.Joints.b2LineJointDef;
	import Box2D.Dynamics.Joints.b2PulleyJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;

	/**
	 * The Joint class makes joining Bodies simpler by combining all different
	 * Box2D joint types together in one wrapper class. Also all functions clearly
	 * define the parameter names and their respective default values.
	 * Box2D r47 or greater required.
	 * (c) 2009 Collin Reisdorf MIT License
	 * 
	 * @author Collin Reisodrf
	 */
	public class Joint
	{
		public static const GEAR:String = "gear";		// GearJoint (not really any docs on this one yet...
		public static const HINGE:String = "hinge";		// RevoluteJoint
		public static const REVOLUTE:String = "hinge";		// RevoluteJoint
		public static const FIXED:String = "fixed";		// RevoluteJoint with 0 degrees of rotation applied
		public static const ROD:String = "rod";			// DistanceJoint
		public static const ARM:String = "rod";
		public static const DISTANCE:String = "rod";
		public static const PULLY:String = "pully";		// PullyJoint
		public static const SLIDE:String = "slide";		// PrismaticJoint
		public static const PRISMATIC:String = "slide";		// PrismaticJoint
		
		private var _body1:b2Body;
		private var _body2:b2Body;
		private var _body1Loc:b2Vec2;
		private var _body2Loc:b2Vec2;
		private var _joint:b2Joint;
//		private var _jointDef:b2JointDef;
		private var _scale:Number;
		private var _speed:Number;
		private var _world:b2World;
		
		
//		public function get axis():
		public function get joint():b2Joint		{	return _joint;	}
		public function get speed():Number		{	return _speed;	}
		
		public function Joint(myWorld:World, body1:b2Body, body2:b2Body, body1Loc:b2Vec2, body2Loc:b2Vec2, type:String="hinge", motorize:Boolean=false, speed:Number=0, torque:Number=10000, length:Number=10, angle:Number=0, axis:b2Vec2=null)
 		{
 			_world = myWorld.world;
 			_scale = myWorld.scale;
 			
 			_body1 = body1;
 			_body2 = body2;
			_body1Loc = body1Loc.Copy();
			_body2Loc = body2Loc.Copy();
			
			_body1Loc.Multiply(-1);
			_body2Loc.Multiply(-1);
			
			
			var jointDef:b2JointDef;
			switch(type)
			{
				case Joint.GEAR:
				jointDef = joinGear(/*some things...*/) as b2GearJointDef;
				break;
				case Joint.FIXED:
				jointDef = joinFixed(angle) as b2RevoluteJointDef;
				break;
				case Joint.ROD:
				jointDef = joinRod(length) as b2DistanceJointDef;
				break;
				case Joint.PULLY:
				jointDef = joinPully(/*some more things*/) as b2PulleyJointDef;
				break;
				case Joint.SLIDE:
				jointDef = joinLine(axis) as b2LineJointDef;
				break;
				default: //Joint.HINGE: (maybe also Fixed too...
				jointDef = joinHinge(motorize, speed, torque) as b2RevoluteJointDef;
				break;
			}
			
			jointDef.body1 = body1;
			jointDef.body2 = body2;
			
			// would be best to add the local anchors here but the stupid b2JointDef base class doesn't define them... 
			
			_joint = _world.CreateJoint(jointDef);
			trace("Created Joint type:", _joint.GetType());
		}
		
		private function joinHinge(motorize:Boolean=false, speed:Number=0, torque:Number=10000):b2RevoluteJointDef
		{
			var jointD:b2RevoluteJointDef = new b2RevoluteJointDef();
				jointD.localAnchor1 = _body1.GetLocalPoint(_body1.GetPosition());
				jointD.localAnchor1.Subtract(new b2Vec2(_body1Loc.x / _scale, _body1Loc.y / _scale));
				jointD.localAnchor2 = _body2.GetLocalPoint(_body2.GetPosition());
				jointD.localAnchor2.Subtract(new b2Vec2(_body2Loc.x / _scale, _body2Loc.y / _scale));
				jointD.referenceAngle = _body1.GetAngle() - _body2.GetAngle();

				jointD.enableMotor = motorize;
				jointD.motorSpeed = speed * (Math.PI / 180);
				_speed = speed;
				jointD.maxMotorTorque = torque;
			return jointD;
		}
		
		private function joinFixed(angle:Number=0):b2RevoluteJointDef
		{

			var jointD:b2RevoluteJointDef = new b2RevoluteJointDef();
				jointD.localAnchor1 = _body1.GetLocalPoint(_body1.GetPosition());
				jointD.localAnchor1.Subtract(new b2Vec2(_body1Loc.x / _scale, _body1Loc.y / _scale));
				jointD.localAnchor2 = _body2.GetLocalPoint(_body2.GetPosition());
				jointD.localAnchor2.Subtract(new b2Vec2(_body2Loc.x / _scale, _body2Loc.y / _scale));
				jointD.referenceAngle = (angle - 180) * (Math.PI/180); trace("WARNING: The fixed joint angle calculation could be reveresed. Please double check.");
				
				
//				jointD.lowerAngle = jointD.upperAngle = jointD.referenceAngle;
				
				jointD.enableLimit = true;
			return jointD;
		}
		
		private function joinRod(length:Number=10):b2DistanceJointDef
		{
			var jointD:b2DistanceJointDef = new b2DistanceJointDef();
				jointD.localAnchor1 = _body1.GetLocalPoint(_body1.GetPosition());
				jointD.localAnchor1.Subtract(new b2Vec2(_body1Loc.x / _scale, _body1Loc.y / _scale));
				jointD.localAnchor2 = _body2.GetLocalPoint(_body2.GetPosition());
				jointD.localAnchor2.Subtract(new b2Vec2(_body2Loc.x / _scale, _body2Loc.y / _scale));
				
				jointD.length = length / _scale;
			return jointD;
		}

		private function joinGear():b2GearJointDef
		{
			var jointD:b2GearJointDef = new b2GearJointDef();
			return jointD;
		}

		private function joinPully():b2PulleyJointDef
		{
			var jointD:b2PulleyJointDef = new b2PulleyJointDef();
			return jointD;
		}
		
		private function joinLine(axis:b2Vec2):b2LineJointDef // slides along an axis relative to body1
		{
			var jointD:b2LineJointDef = new b2LineJointDef();
				jointD.localAnchor1 = _body1.GetLocalPoint(_body1.GetPosition());
				jointD.localAnchor1.Subtract(new b2Vec2(_body1Loc.x / _scale, _body1Loc.y / _scale));
				jointD.localAnchor2 = _body2.GetLocalPoint(_body2.GetPosition());
				jointD.localAnchor2.Subtract(new b2Vec2(_body2Loc.x / _scale, _body2Loc.y / _scale));
				
				jointD.localAxis1 = axis;
				
			return jointD;
		}
	}
}