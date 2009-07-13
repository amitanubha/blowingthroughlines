package
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import flash.utils.setInterval;

	[SWF(width='640', height='360', backgroundColor='#414647', frameRate='30')]
	public class MondoSpider extends Sprite
	{
		private var _world:b2World;
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
		private var _sprite:Sprite;
		
		private var _mouseDown:Boolean = false;
		private var _mousePVec:b2Vec2 = new b2Vec2();
		
		// to test locations
		private var _testerSprite:Sprite;
		private var _allBodies:Array = [];
		
		public function MondoSpider()
		{
			_sprite = new Sprite();
			this.addChild(_sprite);
			
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(-1000.0, -1000.0);
			worldAABB.upperBound.Set(1000.0, 1000.0);
			
			//gravity
			var gravity:b2Vec2 = new b2Vec2(0, 10.0);
			
			// allow sleep
			var doSleep:Boolean = true;
			
			// new world
			_world = new b2World(worldAABB, gravity, doSleep);
			
//			var	debugDraw:b2DebugDraw = new b2DebugDraw();
//			debugDraw.SetSprite(_sprite);
//			debugDraw.SetDrawScale(_physScale);
//			debugDraw.SetFillAlpha(0.3);
//			debugDraw.SetLineThickness(1.0);
//			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
//			_world.SetDebugDraw(debugDraw);
			
			// create walls
			var wallSd:b2PolygonDef = new b2PolygonDef();
			var wallBd:b2BodyDef = new b2BodyDef();
			var wallB:b2Body;
			
			// Left
			wallBd.position.Set(-95 / _physScale, 360/_physScale/2);
			wallSd.SetAsBox(100/_physScale, 400/_physScale/2);
			wallB = _world.CreateBody(wallBd);
			wallB.CreateShape(wallSd);
			wallB.SetMassFromShapes();
			// Right
			wallBd.position.Set((640+95) / _physScale, 360/_physScale/2);
			wallB = _world.CreateBody(wallBd);
			wallB.CreateShape(wallSd);
			wallB.SetMassFromShapes();
			// Top
//			wallBd.position.Set(640/_physScale/2, -95/_physScale);
//			wallSd.SetAsBox(680/_physScale/2, 100/_physScale);
//			wallB = _world.CreateBody(wallBd);
//			wallB.CreateShape(wallSd);
//			wallB.SetMassFromShapes();
			// Bottom
//			wallBd.position.Set(640/_physScale/2, (360+95)/_physScale);
//			wallB = _world.CreateBody(wallBd);
//			wallB.CreateShape(wallSd);
//			wallB.SetMassFromShapes();

			
			
			
 			
 			init();
		}
		
		public function init():void
		{
			trace("world lower bounds:", _world.GetGravity().Length());
			
			this.addEventListener(Event.ENTER_FRAME, update);

			this.graphics.beginFill(0xbada55, 0.1);
			this.graphics.drawCircle(stage.stageWidth/2,stage.stageHeight/2,stage.stageHeight/2);
			
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
			setInterval(addStuff, 500, _world);

			// this is to test location getting!
			_testerSprite = new Sprite();
			_testerSprite.graphics.beginFill(0xbada55, 0.7);
			_testerSprite.graphics.drawRect(-25,-6,50,12);
			_testerSprite.mouseEnabled = false;
			this.addChild(_testerSprite);
			
			addHingedArm(_world, 250, 100);
			addHingedArm(_world, 350, 100);
		}
		
		private function addBridge(world:b2World):void
		{
			var ground:b2Body = world.GetGroundBody();
			var i:int;
			var anchor:b2Vec2 = new b2Vec2();
			var body:b2Body;
		
//			{ //not really sure what this stray bracket was for...
				var sd:b2PolygonDef = new b2PolygonDef();
					sd.SetAsBox(24 / _physScale, 5 / _physScale);
					sd.density = 20.0;
					sd.friction = 0.2;
				
				var bd:b2BodyDef = new b2BodyDef();
				
				var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
				const numPlanks:int = 10;
					jd.lowerAngle = -15 / (180/Math.PI);
					jd.upperAngle = 15 / (180/Math.PI);
					jd.enableLimit = true;
				
				var prevBody:b2Body = ground;
				for (i = 0; i < numPlanks; ++i)
				{
					bd.position.Set((100 + 22 + 44 * i) / _physScale, 250 / _physScale);
					body = world.CreateBody(bd);
					body.CreateShape(sd);
					body.SetMassFromShapes();
					
					anchor.Set((100 + 44 * i) / _physScale, 250 / _physScale);
					jd.Initialize(prevBody, body, anchor);
					world.CreateJoint(jd);
					
					prevBody = body;
				}
				
				anchor.Set((100 + 44 * numPlanks) / _physScale, 250 / _physScale);
				jd.Initialize(prevBody, ground, anchor);
				world.CreateJoint(jd);
//			}
		}

		private function addHingedArm(world:b2World, anchorX:uint, anchorY:uint):void
		{
			
			var ground:b2Body = world.GetGroundBody();
			var i:int;
			var anchor:b2Vec2 = new b2Vec2();
			var body:b2Body;
			

			var sd:b2PolygonDef = new b2PolygonDef();
			sd.SetAsBox(24 / _physScale, 5 / _physScale);
			sd.density = 100.0;
			sd.friction = 0.8;
			
			var bd:b2BodyDef = new b2BodyDef();
			
			var jd:b2RevoluteJointDef = new b2RevoluteJointDef();
//			jd.lowerAngle = -15 / (180/Math.PI);
//			jd.upperAngle = 15 / (180/Math.PI);
			
			jd.enableLimit = false;
			
			var prevBody:b2Body = ground;
			for (i = 0; i < 3; ++i)
			{
				if(i == 0)
				{
				trace("enabled motor damnit");
					jd.enableMotor = true;
					jd.motorSpeed = 1;
					jd.maxMotorTorque = 100;
				}else
				{
					jd.enableMotor = false;

				}
			
				bd.position.Set((anchorX + 22 + 44 * i) / _physScale, anchorY / _physScale);
				body = world.CreateBody(bd);
				body.CreateShape(sd);
				body.SetMassFromShapes();
				
				anchor.Set((anchorX + 44 * i) / _physScale, anchorY / _physScale);
				jd.Initialize(prevBody, body, anchor);
				world.CreateJoint(jd);
				
				prevBody = body;
				_allBodies.push(body);
				
			}
			
			// this was for the other end of the bridge, when this was a bridge
			//anchor.Set((100 + 44 * 3) / _physScale, 250 / _physScale);
			//jd.Initialize(prevBody, ground, anchor);
			//world.CreateJoint(jd);
		}
				
		private function addStuff(world:b2World):void
		{
			// Spawn in a bunch of crap
			
			var body:b2Body;
			var i:uint;
			for (i = 0; i < 5; i++){
				var bodyDef:b2BodyDef = new b2BodyDef();
				//bodyDef.isBullet = true;
				var boxDef:b2PolygonDef = new b2PolygonDef();
				boxDef.density = 1.0;
				// Override the default friction.
				boxDef.friction = 0.3;
				boxDef.restitution = 0.1;
				boxDef.SetAsBox((Math.random() * 5 + 10) / _physScale, (Math.random() * 5 + 10) / _physScale);
				bodyDef.position.Set((Math.random() * 400 + 120) / _physScale, (Math.random() * 150 - 150) / _physScale);
				bodyDef.angle = Math.random() * Math.PI;
				body = world.CreateBody(bodyDef);
				body.CreateShape(boxDef);
				body.SetMassFromShapes();
			}
			for (i = 0; i < 5; i++){
				var bodyDefC:b2BodyDef = new b2BodyDef();
				//bodyDefC.isBullet = true;
				var circDef:b2CircleDef = new b2CircleDef();
				circDef.density = 1.0;
				circDef.radius = (Math.random() * 5 + 10) / _physScale;
				// Override the default friction.
				circDef.friction = 0.3;
				circDef.restitution = 0.1;
				bodyDefC.position.Set((Math.random() * 400 + 120) / _physScale, (Math.random() * 150 - 150) / _physScale);
				bodyDefC.angle = Math.random() * Math.PI;
				body = world.CreateBody(bodyDefC);
				body.CreateShape(circDef);
				body.SetMassFromShapes();
				
			}
//			for (i = 0; i < 5; i++){
//				var bodyDefP:b2BodyDef = new b2BodyDef();
//				//bodyDefP.isBullet = true;
//				var polyDef:b2PolygonDef = new b2PolygonDef();
//				if (Math.random() > 0.66){
//					polyDef.vertexCount = 4;
//					polyDef.vertices[0].Set((-10 -Math.random()*10) / _physScale, ( 10 +Math.random()*10) / _physScale);
//					polyDef.vertices[1].Set(( -5 -Math.random()*10) / _physScale, (-10 -Math.random()*10) / _physScale);
//					polyDef.vertices[2].Set((  5 +Math.random()*10) / _physScale, (-10 -Math.random()*10) / _physScale);
//					polyDef.vertices[3].Set(( 10 +Math.random()*10) / _physScale, ( 10 +Math.random()*10) / _physScale);
//				}
//				else if (Math.random() > 0.5){
//					polyDef.vertexCount = 5;
//					polyDef.vertices[0].Set(0, (10 +Math.random()*10) / _physScale);
//					polyDef.vertices[2].Set((-5 -Math.random()*10) / _physScale, (-10 -Math.random()*10) / _physScale);
//					polyDef.vertices[3].Set(( 5 +Math.random()*10) / _physScale, (-10 -Math.random()*10) / _physScale);
//					polyDef.vertices[1].Set((polyDef.vertices[0].x + polyDef.vertices[2].x), (polyDef.vertices[0].y + polyDef.vertices[2].y));
//					polyDef.vertices[1].Multiply(Math.random()/2+0.8);
//					polyDef.vertices[4].Set((polyDef.vertices[3].x + polyDef.vertices[0].x), (polyDef.vertices[3].y + polyDef.vertices[0].y));
//					polyDef.vertices[4].Multiply(Math.random()/2+0.8);
//				}
//				else{
//					polyDef.vertexCount = 3;
//					polyDef.vertices[0].Set(0, (10 +Math.random()*10) / _physScale);
//					polyDef.vertices[1].Set((-5 -Math.random()*10) / _physScale, (-10 -Math.random()*10) / _physScale);
//					polyDef.vertices[2].Set(( 5 +Math.random()*10) / _physScale, (-10 -Math.random()*10) / _physScale);
//				}
//				polyDef.density = 1.0;
//				polyDef.friction = 0.3;
//				polyDef.restitution = 0.1;
//				bodyDefP.position.Set((Math.random() * 400 + 120) / _physScale, (Math.random() * 150 + 50) / _physScale);
//				bodyDefP.angle = Math.random() * Math.PI;
//				body = world.CreateBody(bodyDefP);
//				body.CreateShape(polyDef);
//				body.SetMassFromShapes();
//			}
		}
		
		public function update(evt:Event):void{
			
			// Update mouse joint
			updateMouseWorld()
			mouseDestroy();
			mouseDrag();
			
			killOffscreens();
			
			// Update physics
			var physStart:uint = getTimer();
			_world.Step(_timeStep, _velocityIterations, _positionIterations);
			
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
			var body:b2Body = b2Body(_allBodies[2]);

			_testerSprite.x = body.GetPosition().x * _physScale;
			_testerSprite.y = body.GetPosition().y * _physScale;
			
			//trace("angle is:", body.GetAngle() * (180 / Math.PI));
			_testerSprite.rotation = body.GetAngle() * (180/ Math.PI);
			
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
				aabb.lowerBound.Set(-100, 9);
				aabb.upperBound.Set(100, 1000);
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