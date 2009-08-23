package
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import com.paperclipped.physics.Body;
	import com.paperclipped.physics.Joint;
	import com.paperclipped.physics.Wall;
	import com.paperclipped.physics.World;
	import com.paperclipped.physics.robotics.Robot;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	[SWF(width='960', height='600', backgroundColor='#333333', frameRate='30')]
	public class MondoSpider extends Sprite
	{
	
		[Embed(source="../assets/textures/cable.png")]
  		private var CableSkin:Class;
  		
		private var _world:b2World;
		private var _myWorld:World;
		private var _mouseJoint:b2MouseJoint
		private var _tester:b2Body;
		private var _velocityIterations:int = 30;
		private var _positionIterations:int = 30;
		private var _timeStep:Number = 1.0/30.0; // need to figure this out!
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
		
		// to test feet movements
		private var _bg:Bitmap;
		private var _robot:Robot;
		private var _robot2:Robot;
		
		// for the debug text
		private var _debugText:TextField;
		
		public function MondoSpider()
		{
 			this.addEventListener(Event.ADDED_TO_STAGE, init); // since we're using the schloader
 			
 			
 			
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
			
			_myWorld = new World(960, 600, debugSprite, debugFlags, new b2Vec2(0,20.0), _physScale);
//			_myWorld = new World(960, 600, debugSprite, debugFlags, new b2Vec2(0,20.0), _physScale, 1000, true, true);
			_world = _myWorld.world;
			
			// For debugging the walk
			addGuides(70, 80);
			
			
//			Inspector.getInstance().init(stage); //NEAT! but not too useful here.
			addWalls();
		
			this.addEventListener(Event.ENTER_FRAME, update);

			var mouseClicker:Sprite = new Sprite();
			mouseClicker.mouseEnabled = true;
//			mouseClicker.buttonMode = true;
			mouseClicker.graphics.beginFill(0xc07712, 0);
			mouseClicker.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			this.addChild(mouseClicker);
			
			mouseClicker.addEventListener(MouseEvent.MOUSE_DOWN, function():void{_mouseDown = true;});
			mouseClicker.addEventListener(MouseEvent.MOUSE_UP, function():void{_mouseDown = false;});
			
			
			// the REAL fun stuff
			_robot2 = new Robot(_myWorld, 250, 550, -6);
			_robot = new Robot(_myWorld, 480, 130, -6, true);
			// for the graphics to work!
			this.addChild(_robot);
			this.addChild(_robot2);
			
			var bgData:BitmapData = new BitmapData(this.stage.stageWidth, this.stage.stageHeight, true, 0);
//			bgData.draw(_design);
			_bg = new Bitmap(bgData);
			_bg.bitmapData = bgData;
			this.addChildAt(_bg, 0);
			
			doublePen();
		}
		
		
		private function doublePen():void
		{
			var pen1:Body = new Body(_myWorld, 600, 100, 60, 10, Body.RECTANGLE, null, -6, 0, true, 0, 1, 1);
			new Joint(_myWorld, _myWorld.world.GetGroundBody(), pen1.body, new b2Vec2(700, 300), new b2Vec2(-30, 0), Joint.ARM, false, 0, 0, 90); 
			
			
//			var pen2:Body = new Body(_myWorld, 660, 300, 40, 10, Body.RECTANGLE, null, -6, -90, true, 0, 1, 1);
			
//			new Joint(_myWorld, pen1.body, _myWorld.world.GetGroundBody(), new b2Vec2(-30, 0), new b2Vec2(570, 300));
//			new Joint(_myWorld, pen1.body, pen2.body, new b2Vec2(30, 0), new b2Vec2(-20, 0));
			
		}
		private function addDebugText():void
		{
			
		}
		
		private function addGuides(one:int, two:int):void
		{
			var guideLines:Shape = new Shape();
 				guideLines.graphics.lineStyle(1, 0xC07712);
 				guideLines.graphics.moveTo(0, stage.stageHeight-one);
 				guideLines.graphics.lineTo(stage.stageWidth, stage.stageHeight-one);
 				guideLines.graphics.lineStyle(1, 0xCA3802);
 				guideLines.graphics.moveTo(0, stage.stageHeight-two);
 				guideLines.graphics.lineTo(stage.stageWidth, stage.stageHeight-two);
 				trace(stage.stageHeight);
 			this.addChild(guideLines);
		}
		
		private function addWalls():void
		{
			var top:Wall = new Wall(_myWorld, Wall.TOP);
//			var bottom:Wall = new Wall(_myWorld, Wall.BOTTOM);
			var bottom:Wall = new Wall(_myWorld, Wall.BOTTOM, 5, 0);
			var left:Wall = new Wall(_myWorld, Wall.LEFT);
			var right:Wall = new Wall(_myWorld, Wall.RIGHT);
			
		}
		
		public function update(evt:Event):void
		{
			
			// Update mouse joint
			updateMouseWorld()
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
			
			// for testering the feet movements
			var bmpData:BitmapData = _bg.bitmapData;
			bmpData.colorTransform(new Rectangle(0,0,_bg.width, _bg.height), new ColorTransform(1,1,1,.99));
//			bmpData.colorTransform(new Rectangle(0,0,_bg.width, _bg.height), new ColorTransform(1,1,1,.8));
//			bmpData.colorTransform(new Rectangle(0,0,_bg.width, _bg.height), new ColorTransform(Math.random(), Math.random(), Math.random()));
			bmpData.draw(_robot);
			bmpData.draw(_robot2);
			_bg.bitmapData = bmpData;
		}
		
		public function updateMouseWorld():void
		{
			_mouseXWorldPhys = (this.mouseX)/_physScale; 
			_mouseYWorldPhys = (this.mouseY)/_physScale; 
			_mouseXWorld = (this.mouseX); 
			_mouseYWorld = (this.mouseY); 
		}
		
		public function mouseDrag():void
		{
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

		private function GetBodyAtMouse(includeStatic:Boolean=false):b2Body
		{
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