package
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.Shapes.b2ShapeDef;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2DistanceJoint;
	import Box2D.Dynamics.Joints.b2DistanceJointDef;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import com.paperclipped.physics.Body;
	import com.paperclipped.physics.Chain;
	import com.paperclipped.physics.Wall;
	import com.paperclipped.physics.World;
	
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import mx.core.BitmapAsset;

	[SWF(width='960', height='360', backgroundColor='#333333', frameRate='30')]
	public class MondoSpider extends Sprite
	{
	
		[Embed(source="../assets/textures/cable.png")]
  		private var CableSkin:Class;
  		
		private var _world:b2World;
		private var _myWorld:World;
		private var _mouseJoint:b2MouseJoint
		private var _tester:b2Body;
		private var _velocityIterations:int = 10;
		private var _positionIterations:int = 10;
		private var _timeStep:Number = 1.0/30.0;
		private var _physScale:Number = 30;
		// world mouse position
		static public var _mouseXWorldPhys:Number;
		static public var _mouseYWorldPhys:Number;
		static public var _mouseXWorld:Number;
		static public var _mouseYWorld:Number;
		// Sprite to draw in to
//		private var _sprite:Sprite;
		
		private var _mouseDown:Boolean = false;
		private var _mousePVec:b2Vec2 = new b2Vec2();
		
		// to test locations
		private var _testerSprite:Sprite;
		private var _allBodies:Array = [];
		
		private var _testRobot:b2Body;
		private var _armSpeed:Number = -2;
		private var _robotReversalAllowed:Boolean = true;
		
		public function MondoSpider()
		{
 			this.addEventListener(Event.ADDED_TO_STAGE, init);
// 			init();
//
//			for( var i:int=1; i < 20; i+=2)
//			{
//				trace(i, i%2, i+(i%2), i+(i%3));
//				
//			}
			
//			var tester:Sprite = new Sprite();
//				tester.graphics.lineStyle(10, 0xbada55, 1, false, "normal", CapsStyle.ROUND, JointStyle.ROUND);
//				tester.graphics.moveTo(300,100);
//				tester.graphics.curveTo(300,200, 400,200);
//			this.addChild(tester);
			
		}
		
		public function init(evt:Event=null):void
		{
			var debugSprite:Sprite = new Sprite();
			this.addChild(debugSprite);
//			debugSprite = null;
//			var debugFlags:uint = (b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit | b2DebugDraw.e_centerOfMassBit);
//			var debugFlags:uint = (b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			var debugFlags:uint = (b2DebugDraw.e_shapeBit);
			
			_myWorld = new World(960, 360, debugSprite, debugFlags, new b2Vec2(0,20.0), _physScale);
			_world = _myWorld.world;
			
			
//			Inspector.getInstance().init(stage); //NEAT! but not too useful here.
			addWalls();
		
//			trace("world lower bounds:", _world.GetGravity().Length());
			
			this.addEventListener(Event.ENTER_FRAME, update);

			var mouseClicker:Sprite = new Sprite();
			mouseClicker.mouseEnabled = true;
//			mouseClicker.buttonMode = true;
			mouseClicker.graphics.beginFill(0xc07712, 0);
			mouseClicker.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.addChild(mouseClicker);
			
			mouseClicker.addEventListener(MouseEvent.MOUSE_DOWN, function():void{_mouseDown = true;});
			mouseClicker.addEventListener(MouseEvent.MOUSE_UP, function():void{_mouseDown = false;});
//			addBridge(_world);
//			addStuff(_world);
			// adds lots of falling things to test speed of app
//			flash.utils.setInterval(addStuff, 2000, _world);

			// this is to test location getting!
//			_testerSprite = new Sprite();
//			_testerSprite.graphics.beginFill(0xbada55, 0.7);
//			_testerSprite.graphics.drawRect(-25,-6,50,12);
//			_testerSprite.mouseEnabled = false;
//			this.addChild(_testerSprite);
			_testRobot = addBox(80, 30, new b2Vec2(50, 360-50), 0);
			trace(_testRobot.GetPosition().x * _physScale);
			
//			addPrimativeLeg(_testRobot);
			for(var i:int=0; i < 1; i++)
			{
				flash.utils.setTimeout(addPrimativeLeg, i*1000, _testRobot);
			}
//			var testerForeArm2:b2Body = addArmToBox(testerArm2, 40, 10, new b2Vec2(-50, 360-50), new b2Vec2(-30, 0));
			
			// need to allow the forearm to move through the robot!!!
			//testerForeArm.
			
			
//			var jointEdge:b2JointEdge = _testRobot.GetJointList();
//			while(jointEdge.next)
//			{
//				trace("found a joint:", jointEdge.next.joint.GetType());
//			}
			
			
//			addChains();
			
			
//			var loc:b2Vec2 = new b2Vec2(300, _myWorld.height - 100);
//			var ner:b2Body = addBox(50, 10, loc, 0);
//			
////			loc = new b2Vec2(300, _myWorld.height - 20);
//			var ner2:b2Body = addBox(50, 10, loc, 0);
//			
//			attachFixed(ner, ner2, new b2Vec2(-30,0), new b2Vec2(30,0), 45);
			
			for(var k:int=0; k < 26; k++)
			{
				var nercle:b2Body = new Body(_myWorld, 400, 100, 30, 20, Body.CIRCLE, null, 0, 0, 0.3, 0.8).body;
			}
			
			var squaner:b2Body = new Body(_myWorld, 450, 150, 30, 30, Body.RECTANGLE).body;
			
			// make triangle
			var triangleVerts:Array = new Array();
				triangleVerts.push(new b2Vec2(50,50));
				triangleVerts.push(new b2Vec2(-50,-50));
				triangleVerts.push(new b2Vec2(50, -50));
			
			var triBody:Body = new Body(_myWorld, 300, 20, 100, 100, Body.TRIANGLE, triangleVerts);
			triBody.addShape(-20, -10, 100);
			
//			var nersticle:Array = new Array();
//			
//			attachRod(triner, squaner, new b2Vec2(-50,-50), new b2Vec2(0,0), 150);
			var statTri:b2Body = Body.staticBody(_myWorld, 300, 300, 100, 100, Body.TRIANGLE, triangleVerts, -2).body;
			

			addStuff(_world);
		}
		
		private function addBox(w:int, h:int, loc:b2Vec2, angle:int=0):b2Body
		{
			// handy for making stiff objects like the robot parts (isBullets!)
			return 	new Body(_myWorld, loc.x, loc.y, w, h, Body.RECTANGLE, null, -2, 0, 0.8, 0.1, 1.0, true).body; //80, 10, new b2Vec2(robot.GetPosition().x, robot.GetPosition().y - (30 / _physScale)));
		}
		
		private function addArmToBox(parent:b2Body, w:int, h:int, loc:b2Vec2, anchor:b2Vec2):b2Body
		{
			
			var arm:b2Body = addBox(w,h,loc);
			
			var joint:b2Joint;
			var jointD:b2RevoluteJointDef = new b2RevoluteJointDef();

			jointD.Initialize(parent, arm, parent.GetWorldPoint(new b2Vec2(anchor.x / _physScale, anchor.y / _physScale)));
			joint = _world.CreateJoint(jointD);
			
			return arm;
		}
		
		private function addArmMotorToBox(parent:b2Body, w:int, h:int, loc:b2Vec2, anchor:b2Vec2, direction:int=-2):b2Body
		{
			trace("adding motor with speed:", direction)
			var arm:b2Body = addBox(w,h,loc);
			var joint:b2RevoluteJoint;
			var jointD:b2RevoluteJointDef = new b2RevoluteJointDef();
				jointD.enableMotor = true;
				jointD.maxMotorTorque = 10000;
				jointD.motorSpeed = direction;
//				jointD.enableLimit = false;
			
//			jointD.Initialize(parent, arm, parent.GetWorldPoint(new b2Vec2(10 / _physScale, 10 / _physScale)));
			jointD.Initialize(parent, arm, parent.GetWorldPoint(new b2Vec2(anchor.x / _physScale, anchor.y / _physScale)));
			joint = _world.CreateJoint(jointD) as b2RevoluteJoint;
			
			return arm;
		}
		
		private function attachHinge(body1:b2Body, body2:b2Body, body1Loc:b2Vec2, body2Loc:b2Vec2, motorize:Boolean=false, speed:Number=0, torque:Number=10000):b2RevoluteJoint
		{
			var jointD:b2RevoluteJointDef = new b2RevoluteJointDef();
				jointD.body1 = body1;
				jointD.body2 = body2;
				jointD.localAnchor1 = body1.GetLocalPoint(body1.GetPosition());
				jointD.localAnchor1.Subtract(new b2Vec2(body1Loc.x / _physScale, body1Loc.y / _physScale));
				jointD.localAnchor2 = body2.GetLocalPoint(body2.GetPosition());
				jointD.localAnchor2.Subtract(new b2Vec2(body2Loc.x / _physScale, body2Loc.y / _physScale));
				jointD.referenceAngle = body1.GetAngle() - body2.GetAngle();

				jointD.enableMotor = motorize;
				jointD.motorSpeed = speed * (Math.PI / 180);
				jointD.maxMotorTorque = torque;

			return _world.CreateJoint(jointD) as b2RevoluteJoint;
		}
		
		private function attachFixed(body1:b2Body, body2:b2Body, body1Loc:b2Vec2, body2Loc:b2Vec2, angle:Number):b2RevoluteJoint
		{

			var jointD:b2RevoluteJointDef = new b2RevoluteJointDef();
				
				jointD.body1 = body1;
				jointD.body2 = body2;
				jointD.localAnchor1 = body1.GetLocalPoint(body1.GetPosition());
				jointD.localAnchor1.Subtract(new b2Vec2(body1Loc.x / _physScale, body1Loc.y / _physScale));
				jointD.localAnchor2 = body2.GetLocalPoint(body2.GetPosition());
				jointD.localAnchor2.Subtract(new b2Vec2(body2Loc.x / _physScale, body2Loc.y / _physScale));
				jointD.referenceAngle = (angle - 180) * (Math.PI/180);
				
				
//				jointD.lowerAngle = jointD.upperAngle = jointD.referenceAngle;
				
				jointD.enableLimit = true;
			
			return _world.CreateJoint(jointD) as b2RevoluteJoint;	
		}
		
		private function attachRod(body1:b2Body, body2:b2Body, body1Loc:b2Vec2, body2Loc:b2Vec2, length:Number=10):b2DistanceJoint
		{
			var jointD:b2DistanceJointDef = new b2DistanceJointDef();
				
				jointD.body1 = body1;
				jointD.body2 = body2;
				jointD.localAnchor1 = body1.GetLocalPoint(body1.GetPosition());
				jointD.localAnchor1.Subtract(new b2Vec2(body1Loc.x / _physScale, body1Loc.y / _physScale));
				jointD.localAnchor2 = body2.GetLocalPoint(body2.GetPosition());
				jointD.localAnchor2.Subtract(new b2Vec2(body2Loc.x / _physScale, body2Loc.y / _physScale));
				
				jointD.length = length / _physScale;
				
			return _world.CreateJoint(jointD) as b2DistanceJoint;	
		}
		
		private function addPrimativeLeg(robot:b2Body):void
		{
			var armLoc:b2Vec2 = new b2Vec2(100, 200);
			var arm1:b2Body = addBox(10, 40, armLoc);
			var arm2:b2Body = addBox(10, 40, armLoc);
			var arm3:b2Body = addBox(10, 40, armLoc);
			
			var speed:Number = 90; // degrees per sec
			var torques:Number = 1000000; // whatever N-m means
			
			attachHinge(robot, arm1, new b2Vec2(60, 0), new b2Vec2(0, 30), true, speed, torques);
			attachHinge(robot, arm2, new b2Vec2(-60, 0), new b2Vec2(0, 30), true, speed, torques);
			attachHinge(robot, arm3, new b2Vec2(0, 0), new b2Vec2(0, 30), true, speed, torques);
			
			var ankle:b2Vec2 = new b2Vec2(0, -36);
			var foot:b2Body = addBox(80, 10, new b2Vec2(robot.GetPosition().x, robot.GetPosition().y - (30 / _physScale)));
			attachHinge(arm1, foot, ankle, new b2Vec2(60, 0));
			attachHinge(arm2, foot, ankle, new b2Vec2(-60, 0));
			attachHinge(arm3, foot, ankle, new b2Vec2(0, 0));
//			var armLoc:b2Vec2 = new b2Vec2(70, 360-50-40);
//			var forearmLoc:b2Vec2 = new b2Vec2(50, 360-(50+80));
//			var armHingeLoc:b2Vec2 = new b2Vec2(20,-10);
//			var foreArmHingeLoc:b2Vec2 = new b2Vec2(0,-20);
//			
//			
////			var testerArm:b2Body = addArmToBox(target, 10, 40, armLoc, armHingeLoc);
//			var testerArm:b2Body = addArmMotorToBox(target, 10, 40, armLoc, armHingeLoc, 2);
//			var testerForeArm:b2Body = addBox(80, 10, forearmLoc);
//			
//			armLoc = new b2Vec2(30, 360-50-40);
//			armHingeLoc = new b2Vec2(-20,-10);		
//			var testerArm2:b2Body = addArmMotorToBox(target, 10, 40, armLoc, armHingeLoc, 2);
//			
//			addJoint(testerArm, testerForeArm, new b2Vec2(0, 40), new b2Vec2(-20, 0));
//			addJoint(testerArm2, testerForeArm, new b2Vec2(0, 40), new b2Vec2(20, 0));
		}
		
		private function addChains():void
		{
			var link:b2PolygonDef = new b2PolygonDef();
				link.SetAsBox(10 / _physScale, 5 / _physScale);
				link.density = 20.0;
				link.friction = 0.2;
				
			var cablelink:b2PolygonDef = new b2PolygonDef();
				cablelink.SetAsBox(10 / _physScale, 6 / _physScale);
				cablelink.density = 100.0;
				cablelink.friction = 0.2;
		
			var chain1:Chain = new Chain(_world, 16, 100, 100, cablelink, 12, Chain.DOWN, 20);
			var chain2:Chain = new Chain(_world, 10, 200, 100, link, 16, Chain.DOWN);
			
			// now to play with texturing!!!
//			addChainTexture(chain1);
			chain2.destroy();
			
		}
		
		private function addChainTexture(target:Chain):void
		{
			for(var i:uint=0; i < target.bodies.length; i++)
			{
				var body:b2Body = target.bodies[i] as b2Body;
				var cableTexture:BitmapAsset = new CableSkin() as BitmapAsset;
					cableTexture.smoothing = true;
					cableTexture.rotation = 90;
//					cableTexture.height = 1;
//					cableTexture.width = 18;
					cableTexture.x = 12;
					cableTexture.y = -6;
					
				var mask:Shape = new Shape();
					mask.graphics.beginFill(0xbada55, .8);
					mask.graphics.drawRoundRect(-12,-6,24,12,10);
				var texture:Sprite = new Sprite();
					texture.addChild(mask);
					texture.addChild(cableTexture);
					cableTexture.mask = mask;
					texture.mouseEnabled = false;
					texture.mouseChildren = false;
				this.addChild(texture);
					body.SetUserData({texture:texture});
				_allBodies.push(body);
			}
		}
		
		private function addRopeTexture(target:Chain):void
		{
			this.addChild(target);
			target.addEventListener(Event.ENTER_FRAME, updateRope);
		}
		

				
		private function addStuff(world:b2World):void
		{
//			// Spawn in a bunch of crap
//			
			var body:b2Body;
			var i:uint;
//			for (i = 0; i < 5; i++){
//				var bodyDef:b2BodyDef = new b2BodyDef();
//				//bodyDef.isBullet = true;
//				var boxDef:b2PolygonDef = new b2PolygonDef();
//				boxDef.density = 1.0;
//				// Override the default friction.
//				boxDef.friction = 0.3;
//				boxDef.restitution = 0.1;
//				boxDef.SetAsBox((Math.random() * 5 + 10) / _physScale, (Math.random() * 5 + 10) / _physScale);
//				bodyDef.position.Set((Math.random() * 400 + 120) / _physScale, (Math.random() * 150 - 150) / _physScale);
//				bodyDef.angle = Math.random() * Math.PI;
//				body = world.CreateBody(bodyDef);
//				body.CreateShape(boxDef);
//				body.SetMassFromShapes();
//			}
//			for (i = 0; i < 5; i++){
//				var bodyDefC:b2BodyDef = new b2BodyDef();
//				//bodyDefC.isBullet = true;
//				var circDef:b2CircleDef = new b2CircleDef();
//				circDef.density = 1.0;
//				circDef.radius = (Math.random() * 5 + 10) / _physScale;
//				// Override the default friction.
//				circDef.friction = 0.3;
//				circDef.restitution = 0.1;
//				bodyDefC.position.Set((Math.random() * 400 + 120) / _physScale, (Math.random() * 150 - 150) / _physScale);
//				bodyDefC.angle = Math.random() * Math.PI;
//				body = world.CreateBody(bodyDefC);
//				body.CreateShape(circDef);
//				body.SetMassFromShapes();
//				
//			}
			for (i = 0; i < 5; i++){
				var bodyDefP:b2BodyDef = new b2BodyDef();
				//bodyDefP.isBullet = true;
				var polyDef:b2PolygonDef = new b2PolygonDef();
				if (Math.random() > 0.66){
					polyDef.vertexCount = 4;
					polyDef.vertices[0].Set((-10 -Math.random()*10) / _physScale, ( 10 +Math.random()*10) / _physScale);
					polyDef.vertices[1].Set(( -5 -Math.random()*10) / _physScale, (-10 -Math.random()*10) / _physScale);
					polyDef.vertices[2].Set((  5 +Math.random()*10) / _physScale, (-10 -Math.random()*10) / _physScale);
					polyDef.vertices[3].Set(( 10 +Math.random()*10) / _physScale, ( 10 +Math.random()*10) / _physScale);
				}
				else if (Math.random() > 0.5){
					polyDef.vertexCount = 5;
					polyDef.vertices[0].Set(0, (10 +Math.random()*10) / _physScale);
					polyDef.vertices[2].Set((-5 -Math.random()*10) / _physScale, (-10 -Math.random()*10) / _physScale);
					polyDef.vertices[3].Set(( 5 +Math.random()*10) / _physScale, (-10 -Math.random()*10) / _physScale);
					polyDef.vertices[1].Set((polyDef.vertices[0].x + polyDef.vertices[2].x), (polyDef.vertices[0].y + polyDef.vertices[2].y));
					polyDef.vertices[1].Multiply(Math.random()/2+0.8);
					polyDef.vertices[4].Set((polyDef.vertices[3].x + polyDef.vertices[0].x), (polyDef.vertices[3].y + polyDef.vertices[0].y));
					polyDef.vertices[4].Multiply(Math.random()/2+0.8);
				}
				else{
					polyDef.vertexCount = 3;
					polyDef.vertices[0].Set(0, (10 +Math.random()*10) / _physScale);
					polyDef.vertices[1].Set((-5 -Math.random()*10) / _physScale, (-10 -Math.random()*10) / _physScale);
					polyDef.vertices[2].Set(( 5 +Math.random()*10) / _physScale, (-10 -Math.random()*10) / _physScale);
				}
				polyDef.density = 1.0;
				polyDef.friction = 0.3;
				polyDef.restitution = 0.1;
				bodyDefP.position.Set((Math.random() * 400 + 120) / _physScale, (Math.random() * 150 + 50) / _physScale);
				bodyDefP.angle = Math.random() * Math.PI;
				body = world.CreateBody(bodyDefP);
				body.CreateShape(polyDef as b2ShapeDef);
				body.SetUserData("ner main");
				body.SetMassFromShapes();
			}
		}
		
		private function addWalls():void
		{
			var top:Wall = new Wall(_myWorld, Wall.TOP);
			var bottom:Wall = new Wall(_myWorld, Wall.BOTTOM);
			var left:Wall = new Wall(_myWorld, Wall.LEFT);
			var right:Wall = new Wall(_myWorld, Wall.RIGHT);
			
		}
		
		public function update(evt:Event):void{
			
			// Update mouse joint
			updateMouseWorld()
			mouseDestroy();
			mouseDrag();
			
//			killOffscreens();
			
			// Update physics
			var physStart:uint = getTimer();
			_world.Step(_timeStep, _velocityIterations, _positionIterations);
			
			for(var i:int=0; i < _allBodies.length; i++)
			{
				var body:b2Body = _allBodies[i] as b2Body;
				if(body.GetUserData().texture)
				{
					var texture:DisplayObject = body.GetUserData().texture as DisplayObject;
						texture.x = body.GetPosition().x * _physScale;
						texture.y = body.GetPosition().y * _physScale;
						texture.rotation = body.GetAngle() * (180/Math.PI);
				}
			}
			
			
			// for reversing the robot when it hist the end
//			if((_testRobot.GetPosition().x <= 80 / _physScale || _testRobot.GetPosition().x >= 520 / _physScale) && _robotReversalAllowed)
//			{
//				
//				var joint:b2Joint = _testRobot.GetJointList().joint;
//				
//				
//				
//				while(!joint is b2RevoluteJoint)
//				{
//					joint = _testRobot.GetJointList().next.joint;
//				}
//				// create timer to block the instant triggering of it again for at least 20 seconds...
//				_robotReversalAllowed = false;
//				flash.utils.setTimeout(function():void{_robotReversalAllowed = true;}, 10000);
//				
//				// reverse the motion of the motor
//				var speed:Number = b2RevoluteJoint(joint).GetMotorSpeed() * -1;
//				b2RevoluteJoint(joint).SetMotorSpeed(speed);
//			}
			
//			var shapes:Array = new Array();
//			var aabb:b2AABB = new b2AABB();
//			aabb.lowerBound.Set(-1000, -1000);
//			aabb.upperBound.Set(1000, 1000);
//			var max:uint = 10;
//			
//			var count:uint = _world.Query(aabb, shapes, max);
//			
//			if(count > 5)
//			{
//				var body:b2Body = (shapes[4] as b2Shape).GetBody();
//				trace(body.GetPosition().x);
//				_testerSprite.x = body.GetPosition().x * 30;
//				
//			}
//			var body:b2Body = b2Body(_allBodies[2]);

			// this was successful, just needs to be moved someplace better.
//			_testerSprite.x = body.GetPosition().x * _physScale;
//			_testerSprite.y = body.GetPosition().y * _physScale;
//			_testerSprite.rotation = body.GetAngle() * (180/ Math.PI);
			
//			Main.m_fpsCounter.updatePhys(physStart);
			
			// Render
			// joints
			/*for (var jj:b2Joint = m_world.m_jointList; jj; jj = jj.m_next){
				//DrawJoint(jj);
			}
			// bodies
			for (var bb:b2Body = m_world.m_bodyList; bb; bb = bb.m_next){
				for (var s:b2Shape = bb.GetShapeList(); s != null; s = s.GetNext()){
					//DrawShape(s);
				}
			}*/
			
			//DrawPairs();
			//DrawBounds();
			
		}
		
		public function updateMouseWorld():void{
			_mouseXWorldPhys = (this.mouseX)/_physScale; 
			_mouseYWorldPhys = (this.mouseY)/_physScale; 
			
			_mouseXWorld = (this.mouseX); 
			_mouseYWorld = (this.mouseY); 
		}
		
		private function updateRope(evt:Event):void //this belongs in a rope class prolly...
		{
			
			var target:Chain = evt.target as Chain;	
			var start:b2Body = target.bodies[0] as b2Body;
			var end:b2Body = target.bodies[target.bodies.length-1] as b2Body;
			target.graphics.clear();
			target.graphics.lineStyle(10, 0xCCCCCC, 1, false, LineScaleMode.NONE, CapsStyle.ROUND, JointStyle.ROUND);
			target.graphics.moveTo(start.GetPosition().x * _physScale, start.GetPosition().y * _physScale);
				
			var last:b2Vec2 = start.GetPosition();
			for(var i:int=1; i < target.bodies.length-1; i++); //i+=3)
			{
				if(target.bodies[i])// && target.bodies[int(i+(i%2))])
				{
					var cont:b2Vec2 = b2Body(target.bodies[i]).GetPosition();
//					var anch:b2Vec2 = b2Body(target.bodies[i]).GetNext().GetPosition();
////					var anch:b2Vec2 = b2Body(target.bodies[int(i+(i%2))]).GetPosition();
					target.graphics.curveTo(last.x * _physScale, cont.y * _physScale, cont.x * _physScale, cont.y * _physScale);
					last = cont;
				}
			}
			
//			target.graphics.lineTo(end.GetPosition().x * _physScale, end.GetPosition().y * _physScale);
			target.graphics.endFill();
		}
		
		public function mouseDrag():void{
			// mouse press
			if (_mouseDown && !_mouseJoint){
				
				var body:b2Body = GetBodyAtMouse();
				
				if (body)
				{
					var md:b2MouseJointDef = new b2MouseJointDef();
					md.body1 = _world.GetGroundBody();
					md.body2 = body;
					md.target.Set(_mouseXWorldPhys, _mouseYWorldPhys);
					md.collideConnected = true;
					md.maxForce = 300.0 * body.GetMass();
					_mouseJoint = _world.CreateJoint(md) as b2MouseJoint;
					body.WakeUp();
				}
			}
			
			
			// mouse release
			if (!_mouseDown){
				if (_mouseJoint)
				{
					_world.DestroyJoint(_mouseJoint);
					_mouseJoint = null;
				}
			}
			
			
			// mouse move
			if (_mouseJoint)
			{
				var p2:b2Vec2 = new b2Vec2(_mouseXWorldPhys, _mouseYWorldPhys);
				_mouseJoint.SetTarget(p2);
			}
		}
		
		public function mouseDestroy():void{
			// mouse press while holding D key deletes things!
//			if (!_mouseDown && Input.isKeyPressed(68/*D*/)){
//				
//				var body:b2Body = GetBodyAtMouse(true);
//				
//				if (body)
//				{
//					_world.DestroyBody(body);
//					return;
//				}
//			}
		}
		
		private function killOffscreens():void
		{
			var aabb:b2AABB = new b2AABB();
				aabb.lowerBound.Set(-1000, 20);
				aabb.upperBound.Set(1000, 1000);
//		
			var k_maxCount:int = 10;
			var shapes:Array = new Array();
			var count:int = _world.Query(aabb, shapes, k_maxCount);
			var body:b2Body = null;
		
			for (var i:int = 0; i < count; ++i)
			{
				// if it's off the screen
				// delete it
					var tShape:b2Shape = shapes[i] as b2Shape;
					_world.DestroyBody(tShape.GetBody());
//					trace(tShape.GetRestitution());
//					var inside:Boolean = tShape.TestPoint(tShape.GetBody().GetXForm(), _mousePVec);
//					if (inside)
//					{
//						body = tShape.GetBody();
//						break;
//					}
				
			}
//			for(var i:int = _world.GetBodyCount(); i > 0; i--)
//			{
//				_world.
//			}
		}
		
		
		public function GetBodyAtMouse(includeStatic:Boolean=false):b2Body{
			// Make a small box.
			_mousePVec.Set(_mouseXWorldPhys, _mouseYWorldPhys);
			var aabb:b2AABB = new b2AABB();
			aabb.lowerBound.Set(_mouseXWorldPhys - 0.001, _mouseYWorldPhys - 0.001);
			aabb.upperBound.Set(_mouseXWorldPhys + 0.001, _mouseYWorldPhys + 0.001);			
			// Query the world for overlapping shapes.
			var k_maxCount:int = 10;
			var shapes:Array = new Array();
			var count:int = _world.Query(aabb, shapes, k_maxCount);
			var body:b2Body = null;
			for (var i:int = 0; i < count; ++i)
			{
				if (shapes[i].GetBody().IsStatic() == false || includeStatic)
				{
					var tShape:b2Shape = shapes[i] as b2Shape;
					var inside:Boolean = tShape.TestPoint(tShape.GetBody().GetXForm(), _mousePVec);
					if (inside)
					{
						body = tShape.GetBody();
						break;
					}
				}
			}
			return body;
		}
	}
}