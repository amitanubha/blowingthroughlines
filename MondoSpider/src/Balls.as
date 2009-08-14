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
	import com.paperclipped.physics.Wall;
	import com.paperclipped.physics.World;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;

	[SWF(width='960', height='600', backgroundColor='#333333', frameRate='90')]
	public class Balls extends Sprite
	{
		private var _world:b2World;
		private var _myWorld:World;
		private var _mouseJoint:b2MouseJoint
		private var _tester:b2Body;
		private var _velocityIterations:int = 10; // higher is slower
		private var _positionIterations:int = 10; // lower is less accurate (examples use 10)
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
		
		private var _debugSprite:Sprite = new Sprite();
		private var _bg:Bitmap;
		private var _nercle:Body;
		
		private var _design:Sprite;
		
		[Embed(source='../fonts/Priva/PrivaOnePro.otf',
			   fontFamily='_PrivaOne',
			   unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')
		]
		public static var _PrivaOnePro:Class;
		
		public function Balls()
		{
 			this.addEventListener(Event.ADDED_TO_STAGE, init); // since we're using the schloader
		}
		
		public function init(evt:Event=null):void
		{
			
//			this.addChild(_debugSprite);
			var debugFlags:uint = (b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
//			_myWorld = new World(960, 600, debugSprite, debugFlags, new b2Vec2(0,20.0), _physScale);
			_myWorld = new World(960, 600, _debugSprite, debugFlags, new b2Vec2(0,20.0), _physScale, 1000, true, true);
			_world = _myWorld.world;
			
			addWalls();
		
			this.addEventListener(Event.ENTER_FRAME, update);

			var mouseClicker:Sprite = new Sprite();
			mouseClicker.mouseEnabled = true;
			mouseClicker.graphics.beginFill(0xc07712, 0);
			mouseClicker.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);	
			this.addChild(mouseClicker);
			
			mouseClicker.addEventListener(MouseEvent.MOUSE_DOWN, function():void{_mouseDown = true;});
			mouseClicker.addEventListener(MouseEvent.MOUSE_UP, function():void{_mouseDown = false;});
			
			_design = new Sprite();
			this.addChildAt(_design, 0);
			
			var increment:int = Math.random()*0xffffff;
			
			for(var k:int=0; k < 5; k++)
			{
				var diameter:Number = Math.random()*100;
				diameter+=5;
				
				var nerDesign:Shape = new Shape();
				nerDesign.graphics.beginFill(increment, 0.3);
				nerDesign.graphics.lineStyle(1, increment);
				nerDesign.graphics.drawCircle(diameter / 2, diameter / 2, diameter / 2);
				nerDesign.graphics.endFill();
				nerDesign.graphics.moveTo(0, diameter / 2);
				nerDesign.graphics.lineTo(diameter, diameter / 2);
				_design.addChildAt(nerDesign, 0);
				
				_nercle = new Body(_myWorld, (k%20)*diameter+20, diameter, diameter, 0, Body.CIRCLE, null, 0, 0, true, 0.3, 1.02, 1); //isBullet // tooooo slow!
				_nercle.graphic = nerDesign;
//				var nercle:b2Body = new Body(_myWorld, (k%20)*20, (k%20)*10, 30, 20, Body.CIRCLE, null, 0, 0, false, 0.3, 0.8).body; // isNotBullet

				increment += increment;
			}
			
			var bgData:BitmapData = new BitmapData(this.stage.stageWidth, this.stage.stageHeight, true, 0xFFFFFF);
//			bgData.draw(_design);
			_bg = new Bitmap(bgData);
			_bg.bitmapData = bgData;
			this.addChildAt(_bg, 0);
		}
		
		private function addWalls():void
		{
			var top:Wall = new Wall(_myWorld, Wall.TOP, 0);
			var bottom:Wall = new Wall(_myWorld, Wall.BOTTOM, 0);
			var left:Wall = new Wall(_myWorld, Wall.LEFT, 0);
			var right:Wall = new Wall(_myWorld, Wall.RIGHT, 0);
		}
		
		public function update(evt:Event):void{
			
			// Update mouse joint
			updateMouseWorld()
			mouseDrag();
			
			
			// Update physics
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
			var bmpData:BitmapData = _bg.bitmapData;
			bmpData.colorTransform(new Rectangle(0,0,_bg.width, _bg.height), new ColorTransform(1,1,1,.99));
//			bmpData.colorTransform(new Rectangle(0,0,_bg.width, _bg.height), new ColorTransform(1,1,1,.8));
//			bmpData.colorTransform(new Rectangle(0,0,_bg.width, _bg.height), new ColorTransform(Math.random(), Math.random(), Math.random()));
			bmpData.draw(_design);
			_bg.bitmapData = bmpData;
//			_bg.filters = [new BlurFilter()];
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