package {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import com.boristhebrave.Box2D.Controllers.b2SpringController;
	import com.paperclipped.physics.Body;
	import com.paperclipped.physics.Joint;
	import com.paperclipped.physics.World;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;

	[SWF(backgroundColor="#333333", width="800", height="600")]
	public class MeccanoMath extends Sprite
	{
		private var _velocityIterations:int = 30;
		private var _positionIterations:int = 30;
		private var _timeStep:Number = 1.0/30.0; // need to figure this out!
		private var _physScale:Number = 30;
		
		private var _world:b2World;
		private var _spring:b2SpringController = new b2SpringController();
		private var _spring2:b2SpringController = new b2SpringController();
		
		private var _wheel:Body;
		private var _wheelJoint:Joint;
		public function MeccanoMath()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(evt:Event=null):void
		{
			var debugSprite:Sprite = new Sprite();
			this.addChild(debugSprite);
			var myWorld:World = new World(800, 600, debugSprite, b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			_world = myWorld.world;
			
			var center:b2Vec2 = new b2Vec2(0,0);
			var wheel2Elbow:b2Vec2 = new b2Vec2(40, 0);
			
			_wheel 		= new Body(myWorld, 200, 300, 80, 0, Body.CIRCLE, null, -2);
			var topElbow:Body 	= new Body(myWorld, 300, 100, 10, 0, Body.CIRCLE, null);
			var botElbow:Body 	= new Body(myWorld, 300, 400, 10, 0, Body.CIRCLE, null);
			var hand:Body 		= new Body(myWorld, 300, 400, 10, 0, Body.CIRCLE, null, -2);
			
			_wheelJoint = new Joint(myWorld, myWorld.world.GetGroundBody(), _wheel.body, new b2Vec2(200, 300), center, "hinge", true, -30, 10000, 10, -180);
			
			new Joint(myWorld, myWorld.world.GetGroundBody(), topElbow.body, new b2Vec2(240, 300), center, Joint.ARM, false, 0, 0, 60);
			new Joint(myWorld, myWorld.world.GetGroundBody(), botElbow.body, new b2Vec2(240, 300), center, Joint.ARM, false, 0, 0, 60);
			
			new Joint(myWorld, _wheel.body, topElbow.body, wheel2Elbow, center, Joint.ARM, false, 0, 0, 100);
			new Joint(myWorld, _wheel.body, botElbow.body, wheel2Elbow, center, Joint.ARM, false, 0, 0, 100);
			
			new Joint(myWorld, hand.body, topElbow.body, center, center, Joint.ARM, false, 0, 0, 100);
			new Joint(myWorld, hand.body, botElbow.body, center, center, Joint.ARM, false, 0, 0, 100);
			
			
			_spring.SetBody1(topElbow.body); // doesn't seem to work
			_spring.SetBody2(botElbow.body);
			
			_spring.length = 10;
			_spring.damping = 0.5;
			_spring.k	= 20;
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(1, 0xbada55);
			shape.graphics.moveTo(320, 0);
			shape.graphics.lineTo(320, stage.stageHeight);
			this.addChild(shape);
			
			
			var body:Body = new Body(myWorld, 600, 100, 60)
			
			new Joint(myWorld, _world.GetGroundBody(), body.body, new b2Vec2(600, 100), center);
			
			_spring2.SetBody1(body.body); // doesn't seem to work
			_spring2.SetBody2(new Body(myWorld, 100, 130, 60).body);
			
			_spring2.length = 3;
			_spring2.damping = 0.5;
			_spring2.k = 200; // for affecting force
			
		}
		
		public function update(evt:Event):void
		{
			
			// Update physics
//			var physStart:uint = getTimer(); // just for fps meter which i'm not bothering with
			_spring.Step(_timeStep);
			_spring2.Step(_timeStep);
			_world.Step(_timeStep, _velocityIterations, _positionIterations);
			_spring.Draw(_world.GetDebugDraw());
			_spring2.Draw(_world.GetDebugDraw());
			
			var wheelAngle:Number = _wheel.body.GetAngle() * (180 / Math.PI);
			
			if(wheelAngle < -290)
				_wheelJoint.speed = 30;
			else if(wheelAngle > -70)
				_wheelJoint.speed = -30;
			
			
			trace(_wheel.body.GetAngle() * (180 / Math.PI));
//			_spring.Draw(_world.GetDebugDraw());
			
//			for(var i:int=0; i < _allBodies.length; i++)
//			{
//				var body:b2Body = _allBodies[i] as b2Body;
//				if(body.GetUserData().texture)
//				{
//					var texture:DisplayObject = body.GetUserData().texture as DisplayObject;
//						texture.x = body.GetPosition().x * _physScale;
//						texture.y = body.GetPosition().y * _physScale;
//						texture.rotation = body.GetAngle() * (180/Math.PI);
//				}
//			}
//			
//			// for testering the feet movements
//			var bmpData:BitmapData = _bg.bitmapData;
//			bmpData.colorTransform(new Rectangle(0,0,_bg.width, _bg.height), new ColorTransform(1,1,1,.99));
////			bmpData.colorTransform(new Rectangle(0,0,_bg.width, _bg.height), new ColorTransform(1,1,1,.8));
////			bmpData.colorTransform(new Rectangle(0,0,_bg.width, _bg.height), new ColorTransform(Math.random(), Math.random(), Math.random()));
//			bmpData.draw(_robot);
//			bmpData.draw(_robot2);
//			_bg.bitmapData = bmpData;
		}
		
	}
}
