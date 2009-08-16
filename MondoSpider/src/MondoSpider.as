package
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import com.paperclipped.physics.Body;
	import com.paperclipped.physics.Chain;
	import com.paperclipped.physics.Joint;
	import com.paperclipped.physics.Wall;
	import com.paperclipped.physics.World;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[SWF(width='960', height='600', backgroundColor='#333333', frameRate='30')]
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
		
		private var _mondoWheelJoint:Joint;
		private var _spiderMotors:Array = new Array();
		private var _step:uint = 0;
		
		public function MondoSpider()
		{
 			this.addEventListener(Event.ADDED_TO_STAGE, init); // since we're using the schloader
 			
// 			var circleDots:Sprite = new Sprite();
// 			circleDots.graphics.beginFill(0x123456, 0.8);
// 			circleDots.graphics.drawCircle(0,0,100);
// 			
// 			var segments:int = 6;
// 			var angle:Number = 360 / segments;
// 				angle *= (Math.PI/180);
// 			
// 			for(var i:int=0; i < segments; i++)
// 			{
// 				var dotX:Number = 100*Math.cos(angle*i)+0;
//				var dotY:Number = 100*Math.sin(angle*i)+0;
//				circleDots.graphics.drawCircle(dotX, dotY, 10);
// 			}
// 			
// 			circleDots.graphics.endFill();
// 			circleDots.graphics.beginFill(0xFFFFFF, 1);
// 			circleDots.graphics.drawCircle(0.5,0.5,0.5);
// 			circleDots.graphics.endFill();
// 			
// 			circleDots.graphics.beginFill(0xFFFFFF);
// 			circleDots.graphics.drawRect(5, 0, 1, 1);
// 			circleDots.graphics.endFill();
// 			
// 			circleDots.x = 400;
// 			circleDots.y = 300;
// 			
// 			this.addChild(circleDots);
 			
 			
		}
		
		public function init(evt:Event=null):void
		{
			var debugSprite:Sprite = new Sprite();
			this.addChild(debugSprite);
//			debugSprite = null;
//			var debugFlags:uint = (b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit | b2DebugDraw.e_centerOfMassBit);
			var debugFlags:uint = (b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
//			var debugFlags:uint = (b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit | b2DebugDraw.e_aabbBit); // AABB is Axis-Aligned Bounding Box
//			var debugFlags:uint = (b2DebugDraw.e_shapeBit);
			
//			_myWorld = new World(960, 600, debugSprite, debugFlags, new b2Vec2(0,20.0), _physScale);
			_myWorld = new World(960, 600, debugSprite, debugFlags, new b2Vec2(0,20.0), _physScale, 1000, true, true);
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

			// Test Simple Walker (rotating parallel bar)
//			_testRobot = new Body(_myWorld, 100, 100, 180, 60, Body.RECTANGLE).body;
//			addPrimativeLeg(_testRobot);
//			for(var i:int=0; i < 4; i++)
//			{
//				flash.utils.setTimeout(addPrimativeLeg, i*1000, _testRobot);
//			}
			
			//Chains test
//			addChains();
			
			//Fixed Joint Test
//			var loc:b2Vec2 = new b2Vec2(300, _myWorld.height - 100);
//			var ner:b2Body = addBox(50, 10, loc, 0);
//			
////			loc = new b2Vec2(300, _myWorld.height - 20);
			
			for(var k:int=0; k < 5; k++)
			{
//				var nercle:b2Body = new Body(_myWorld, 400, 100, 30, 20, Body.CIRCLE, null, 0, 0, false, 0.3, 0.8).body;
			}
			
//			var squaner:b2Body = new Body(_myWorld, 450, 150, 30, 30, Body.RECTANGLE).body;
			
			// make triangle
			var triangleVerts:Array = new Array();
				triangleVerts.push(new b2Vec2(50,50));
				triangleVerts.push(new b2Vec2(-50,-50));
				triangleVerts.push(new b2Vec2(30, -50));
			
//			var triBody:Body = new Body(_myWorld, 300, 20, 100, 100, Body.CIRCLE, triangleVerts);
////			triBody.addShape(-20, -10, 100);
//			triBody.addShape(-100, 20, 0, 0, triangleVerts, Body.TRIANGLE, -2);
//			triBody.updateMass();
////			var nersticle:Array = new Array();
////			
////			attachRod(triner, squaner, new b2Vec2(-50,-50), new b2Vec2(0,0), 150);
//			var statTri:b2Body = Body.staticBody(_myWorld, 300, 400, 100, 100, Body.TRIANGLE, triangleVerts, -2).body;

//			addStuff(_world);
			
			
			// test spinning bar with stuff
//			var highLoc:b2Vec2 = new b2Vec2(200,250);
//			var wheelDiamter:int = 80;
//			
////			var highBox:b2Body = Body.staticBody(_myWorld, highLoc.x, highLoc.y, 120, 80, Body.RECTANGLE, null, -3).body;
//			var highBox:b2Body = new Body(_myWorld, highLoc.x, highLoc.y, 200, 80, Body.RECTANGLE, null, -3, 0, true).body;
//			var highWheel:b2Body = new Body(_myWorld, highLoc.x, highLoc.y, wheelDiamter, 0, Body.CIRCLE, null, -3, 0, true).body;
//			var highAxelLoc:b2Vec2 = new b2Vec2(6,0);
//			
//			new Joint(_myWorld, highBox, highWheel, highAxelLoc, new b2Vec2(0,0), Joint.HINGE, true, 60);
//
//			var arms:int = 20; // number of arms to add
//			
//			var theta:Number = (360 / arms)*(Math.PI/180);
//			var wheelLoc:b2Vec2 = new b2Vec2();
//			var armLoc:b2Vec2 = new b2Vec2(10, 0);
//			
//			for(var m:int=0; m < arms; m++)
//			{
//				var arm:b2Body = new Body(_myWorld, highLoc.x-60, highLoc.y, 100, 10, Body.RECTANGLE, null, -3, -90, true).body;
//					wheelLoc.x = (wheelDiamter/2 - 10) * Math.cos(theta * m) + 0;
//					wheelLoc.y = (wheelDiamter/2 - 10) * Math.sin(theta * m) + 0;
//				new Joint(_myWorld, highWheel, arm, wheelLoc, armLoc, Joint.HINGE);
//				new Joint(_myWorld, highBox, arm, new b2Vec2(highAxelLoc.x + 50, highAxelLoc.y + 30), new b2Vec2(-40, 0), Joint.ARM, false, 0, 0, 50);
//			}
//
//			var gear1:b2Body = new Body(_myWorld, 500, 200, 200, 0, Body.CIRCLE).body;
//			new Joint(_myWorld, _world.GetGroundBody(), gear1, new b2Vec2(-500, -200), new b2Vec2(0,0), Joint.HINGE);
//			
//			var sensoWall:Sensor = Sensor.staticSensor(_myWorld, 910, 550, 100, 100);
////			var sensoWall:Body = Body.staticBody(_myWorld, 910, 550, 100, 100, Body.CIRCLE, null, 0, 0, 0.3, true);
////			var sensoShapes:Array = sensoWall.body.GetShapeList();
//
//			for (var sensoShape:b2Shape = sensoWall.body.GetShapeList(); sensoShape; sensoShape = sensoShape.GetNext())
//			{
//			    trace("found sensoShape:", sensoShape, "is sensor?:", sensoShape.IsSensor(), "next sensoShape:", sensoShape.GetNext());
//			    if(sensoShape.IsSensor())
//			    {
//			    	var filterData:b2FilterData = sensoShape.GetFilterData()
////			    		filterData.
//			    }
//			}
			
//			var mondoBody:Body = Body.staticBody(_myWorld, 300, 200, 200, 100, Body.RECTANGLE, null, -6);
			var mondoBody:Body = new Body(_myWorld, 300, 400, 200, 100, Body.RECTANGLE, null, -6);
//			var mondoBody:Body = new Body(_myWorld, 150, 400, 200, 100, Body.RECTANGLE, null, -6, 0, true, 0.3, 0.1, 1);
			
			createMondoLeg(mondoBody, 2, -50, 20, "left");
			createMondoLeg(mondoBody, 2, 50, 20, "right");
			
			//add training wheel!
//			var mondoWheel:Body = new Body(_myWorld, 250, 500, 40, 0, Body.CIRCLE, null, -6, 0, true);
//			new Joint(_myWorld, mondoBody.body, mondoWheel.body, new b2Vec2(100, 85), new b2Vec2(0,0));

//			makeTriangle(1);
//			makeTriangle(-1);
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
//			_spiderMotors.push(new Joint(_myWorld, parent.body, wheel.body, new b2Vec2(x,y), new b2Vec2(0,0), Joint.HINGE, true, -90));
			
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
			
//			var thigh2WheelAxis:b2Vec2 	= new b2Vec2( 51 * dir, -6);
//			var thigh2FootAxis:b2Vec2 	= new b2Vec2(-50 * dir,  6);
//			
//			var ankle2ParentAxis:b2Vec2 = new b2Vec2(x+(-46 * dir), y+14);
//			var shin2ParentAxis:b2Vec2	= new b2Vec2(x+(-3* dir), 	y-38);
//			var ankle2ThighAxis:b2Vec2	= new b2Vec2(5 * dir, 5);

			
			for(var i:int=0; i < legCount; i++)
			{
				var thigh2WheelAxis:b2Vec2 	= new b2Vec2( 51 * dir, -6);
				var thigh2FootAxis:b2Vec2 	= new b2Vec2(-50 * dir,  6);
				
				var ankle2ParentAxis:b2Vec2 = new b2Vec2(x+(-46 * dir), y+14);
				var shin2ParentAxis:b2Vec2	= new b2Vec2(x+(-3* dir), 	y-38);
				var ankle2ThighAxis:b2Vec2	= new b2Vec2(5 * dir, 5);
				
				var foot2ThighAxis:b2Vec2 	= b2Vec2(footVerts[1]).Copy();
				var shin2FootAxis:b2Vec2	= b2Vec2(footVerts[shin2FootVert]).Copy(); //b2Vec2(footVerts[2]).Copy(); //new b2Vec2(-28.5 * dir, 95.5);
				
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
		
		private function addBox(w:int, h:int, loc:b2Vec2, angle:int=0):b2Body
		{
			// handy for making stiff objects like the robot parts (isBullets!)
			return 	new Body(_myWorld, loc.x, loc.y, w*2, h*2, Body.RECTANGLE, null, -2, 0, true, 0.8, 0.1, 1.0).body; //80, 10, new b2Vec2(robot.GetPosition().x, robot.GetPosition().y - (30 / _physScale)));
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
			
			jointD.Initialize(parent, arm, parent.GetWorldPoint(new b2Vec2(anchor.x / _physScale, anchor.y / _physScale)));
			joint = _world.CreateJoint(jointD) as b2RevoluteJoint;
			
			return arm;
		}
		
		private function addPrimativeLeg(robot:b2Body):void
		{
			var armLoc:b2Vec2 = new b2Vec2(100, 200);
			var arm1:b2Body = addBox(10, 40, armLoc);
			var arm2:b2Body = addBox(10, 40, armLoc);
			var arm3:b2Body = addBox(10, 40, armLoc);
			
			var speed:Number = 90; // degrees per sec
			var torques:Number = 1000000; // whatever N-m means
			
			new Joint(_myWorld, robot, arm1, new b2Vec2(60, 0), new b2Vec2(0, 30), Joint.HINGE, true, speed, torques);
			new Joint(_myWorld, robot, arm2, new b2Vec2(-60, 0), new b2Vec2(0, 30), Joint.HINGE, true, speed, torques);
			new Joint(_myWorld, robot, arm3, new b2Vec2(0, 0), new b2Vec2(0, 30), Joint.HINGE, true, speed, torques);
			
			var ankle:b2Vec2 = new b2Vec2(0, -36);
			var foot:b2Body = addBox(80, 10, new b2Vec2(robot.GetPosition().x, robot.GetPosition().y - (30 / _physScale)));
			new Joint(_myWorld, arm1, foot, ankle, new b2Vec2(60, 0), Joint.HINGE);
			new Joint(_myWorld, arm2, foot, ankle, new b2Vec2(-60, 0), Joint.HINGE);
			new Joint(_myWorld, arm3, foot, ankle, new b2Vec2(0, 0), Joint.HINGE);

		}
		
		private function addChains():void
		{
			var link:b2PolygonDef = new b2PolygonDef();
				link.SetAsBox(10 / _physScale, 5 / _physScale);
				link.density = 1.0;
				link.friction = 0.2;
				link.filter.groupIndex = -2
				
			var cablelink:b2PolygonDef = new b2PolygonDef();
				cablelink.SetAsBox(10 / _physScale, 6 / _physScale);
				cablelink.density = 1.0;
				cablelink.friction = 0.2;
				cablelink.filter.groupIndex = -2
		
			var chain1:Chain = new Chain(_world, 15, 700, 15, cablelink, 12, Chain.DOWN, 20);
			var chain2:Chain = new Chain(_world, 10, 800, 100, link, 16, Chain.DOWN);
			
			// now to play with texturing!!!
			chain2.destroy();
			
			var desc:b2Body = new Body(_myWorld, 700, 300, 360, 200, Body.RECTANGLE, null, -2, 0, false, 0.3, 0.9, 0.01).body;
			new Joint(_myWorld, chain1.bodies[chain1.bodies.length-1] as b2Body, desc, new b2Vec2(0,0), new b2Vec2(0, 80), Joint.HINGE);
		}
		
		private function addWalls():void
		{
			var top:Wall = new Wall(_myWorld, Wall.TOP);
			var bottom:Wall = new Wall(_myWorld, Wall.BOTTOM);
			var left:Wall = new Wall(_myWorld, Wall.LEFT);
			var right:Wall = new Wall(_myWorld, Wall.RIGHT);
			
		}
		
		private function makeTriangle(dir:int, x:int=600, y:int=300):void
		{
			var ner:Shape = new Shape();
			ner.graphics.beginFill(0xFFFFFF);
			ner.graphics.drawRect(x,y,1,1);
			ner.graphics.endFill();
			this.addChild(ner);
			
			
			var verts:Array = new Array( 	
											new b2Vec2( 48.5  * dir, -95.5), // Top
											new b2Vec2(-8.5 * dir,   -27.5), // Middle
											new b2Vec2(-7.5 * dir,    95.5)  // Bottom
											);
											
			if(dir == 1) verts = verts.reverse();
											
			var xLoc:Number = x-(71 * dir);
			var t:Body = new Body(_myWorld, xLoc, y, 0, 0, Body.TRIANGLE, verts, -4);
			
			new Joint(_myWorld, _myWorld.world.GetGroundBody(), t.body, new b2Vec2(x,y), new b2Vec2(0,0), Joint.ARM, false, 0, 0, 71);
		}
		
		public function update(evt:Event):void{
			
			// Update mouse joint
			updateMouseWorld()
			mouseDestroy();
			mouseDrag();
			
//			killOffscreens();
			
			// Update physics
//			var physStart:uint = getTimer(); // just for fps meter which i'm not bothering with
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
			}
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