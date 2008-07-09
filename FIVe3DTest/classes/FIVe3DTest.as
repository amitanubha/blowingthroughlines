package {
	import caurina.transitions.Tweener;
	
	import com.huntandgather.lda.display.Plane53D;
	
	import five3D.display.Bitmap3D;
	import five3D.display.Scene3D;
	import five3D.display.Sprite3D;
	import five3D.geom.Point3D;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	public class FIVe3DTest extends Sprite
	{	
		private var _scene:Scene3D;
		private var _planes:Array;
		private var _projects:Array;
		private var _data:XML;
		
		private var _averageFPS:Number;
		private var _currentFPS:Number;
		private var _renderTime:Number;
		private var _fpsArray:Array;
		private var _fpsTxt:TextField;
		
		private var _animatedPlane:Bitmap3D;
		private var _frames:Array;
		
		// temp
		private var _bmp:Bitmap;
		
		public function FIVe3DTest()
		{
			stage.frameRate = 90;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align		= StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, handleStageResize);
			trace("five3D exists");
			flash.utils.setTimeout(init, 1000);
		}
		
		private function init():void
		{
			trace("running the init function");
			_scene 	= new Scene3D();
			_planes = new Array();
			_scene.addEventListener(Event.ENTER_FRAME, setChildIndecies);
			
			
			populateScene();
			this.addChild(_scene);
			
			addFPSDisplay();
			this.addEventListener(Event.ENTER_FRAME, getFPS);

			var testerPlane:Sprite3D = new Sprite3D();
			var animatedMaterial:AnimatedPlaneMC = new AnimatedPlaneMC();
			//testerMaterial.stop();
			
			var testerFrames:Array = new Array();
			for(var i:uint=1; i <= animatedMaterial.totalFrames; i++)
			{
				animatedMaterial.gotoAndStop(i);
				var bmpData:BitmapData = new BitmapData(animatedMaterial.width, animatedMaterial.height, true, 0xBADA55);
				bmpData.draw(animatedMaterial);
				testerFrames.push(bmpData);
			}
			
//			var bmp:Bitmap = new Bitmap(testerFrames[testerFrames.length-1]);
//			bmp.x = 800;
//			trace(this.numChildren);
//			this.addChild(testerMaterial);
//			trace(this.numChildren, bmp.width, bmp.height, bmp.parent);
			
			_frames = ripFrames(animatedMaterial);
			animateBMP(_frames);

			
			_animatedPlane = new Bitmap3D();
			_animatedPlane.smoothing = true;
			_animatedPlane.bitmapData = BitmapData(testerFrames[5]);
//			testerPlane.addChild(testerBmp);
			_animatedPlane.rotationX = 30;
			_animatedPlane.rotationY = 30;
			_animatedPlane.x = 400;
			_animatedPlane.y = 200;
			_animatedPlane.alpha = 0.4;
//			testerPlane.addChild(testerMaterial);
			_scene.addChild(_animatedPlane);
			
			// temp
			_bmp = new Bitmap();
			this.addChildAt(_bmp, 0);
			
			handleStageResize();
		}
		
		private function populateScene():void
		{
			for( var i:uint=0; i < 15; i++)
			{
				var plane:Plane53D 	= new Plane53D();
				var w:Number 		= 200; //Math.round(Math.random()*100)+200;
				var h:Number 		= 200; //Math.round(Math.random()*100)+200;
				
				w -= w%2;
				h -= h%2;
				
				var planeGraphics:Sprite = new Sprite();
				planeGraphics.graphics.beginFill(0xBADA55, 1);
				planeGraphics.graphics.drawRoundRect(0, 0, w, h, 20, 20);
				var testFormat:TextFormat = new TextFormat("_sans", 62, 0x123456, "bold");
				var testText:TextField = new TextField();
				testText.defaultTextFormat = testFormat;
				testText.text = "Ner "+i;
				testText.autoSize = "left";
				planeGraphics.addChild(testText);
				
				var bmpData:BitmapData = new BitmapData(planeGraphics.width, planeGraphics.height, true, 0);
				bmpData.draw(planeGraphics);
				plane.bitmapData = bmpData;
				
//				plane.graphics3D.beginFill(0xBADA55, 1);
//				plane.graphics3D.drawRoundRect(-w/2, -h/2, w, h, 20, 20);
				
				plane.alpha 		= 0.6;
				plane.x 			= Math.round((Math.random()*stage.stageWidth)-stage.stageWidth/2) - 200;
				plane.y 			= Math.round((Math.random()*stage.stageHeight)-stage.stageHeight/2) - 200;
				plane.z 			= Math.round(Math.random()*3000);
				
//				plane.x 			= 300;
//				plane.y 			= 600;
//				plane.z 			= 1500;
				
				plane.origin 		= new Point3D(plane.x, plane.y, plane.z);

				

				_scene.addChild(plane);
				_planes.push(plane);
			}
			
			
//			var dot:Shape3D = new Shape3D();
//			dot.graphics3D.beginFill(0x00CC00, 0.4);
//			dot.graphics3D.drawCircle(0,0,9);
//			_scene.addChildAt(dot, 0);
			
			
			
//			var tester:Sprite2D = new Sprite2D();
//			tester.graphics.beginFill(0x0000CC, 0.7);
//			tester.graphics.drawRect(-100, -100, 200, 200);
//			
//			var spinner:Shape3D = new Shape3D();
//			spinner.graphics3D.beginFill(0x993300, 0.7);
//			spinner.graphics3D.drawRect(-100, -100, 200, 200);
//			
//			var test:Sprite3D = new Sprite3D();
//			test.z = 10;
//			test.rotationX = 45;
//			test.rotationY = 45;
//			test.rotationZ = 45;
//			test.addChild(tester);
//			test.addChild(spinner);
//			_scene.addChild(test);
//			
//			test.buttonMode = true;
//			test.mouseChildren = false;
//			test.addEventListener(MouseEvent.CLICK, handleTesterClick);
		}
		
		private function handleTesterClick(evt:MouseEvent):void
		{
			trace("tester was clicked");
			evt.target.x += Math.random()*200 - 100;
			evt.target.y += Math.random()*200 - 100;
			evt.target.z += Math.random()*500 - 250;
			Tweener.addTween(evt.target, {x:0, y:0, z:10, time:0.75, transition:"easeoutelastic"});
		}
		
		private function setChildIndecies(evt:Event/* scene:Scene3D */):void
		{
			var scene:Scene3D 	= Scene3D(evt.currentTarget);
			var planes:Array	= new Array();
			for(var i:uint=0; i < scene.numChildren; i++)
			{
				if(scene.getChildAt(i) is Sprite3D)
				{
					var plane:Sprite3D = Sprite3D(scene.getChildAt(i));
					planes.push(plane);
				}
			}
			
			planes.sortOn("z", Array.NUMERIC | Array.DESCENDING);
			
			for(var k:uint=0; k < planes.length; k++)
			{
				scene.setChildIndex(Sprite3D(planes[k]), k);
			}
			
			// temp code
			var bmpData:BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight,true, 0);
			bmpData.draw(this);
			_bmp.bitmapData = bmpData;
			_bmp.alpha = 0.8;
		}
		
		private function animateBMP(frames:Array):void
		{
			var timer:Timer = new Timer(1000/stage.frameRate, 0);
			timer.addEventListener(TimerEvent.TIMER, playFrame);
			timer.start();
		}
		
		private function playFrame(evt:TimerEvent):void
		{
			var timer:Timer = Timer(evt.currentTarget)
			if(timer.currentCount > _frames.length-1)
			{
				timer.reset();
				timer.start();
			}
			trace(timer.currentCount, _frames[timer.currentCount]);
			_animatedPlane.bitmapData = _frames[timer.currentCount];
			
			// temp
			_animatedPlane.rotationY += 3; //_animatedPlane.x - (mouseX * 0.5);
		}
		
		private function ripFrames(mc:MovieClip):Array
		{
			var frames:Array = new Array();
			for(var i:uint=0; i < mc.totalFrames; i++)
			{
				mc.gotoAndStop(i+1);
				var bmpData:BitmapData = new BitmapData(mc.width, mc.height, true, 0xBADA55);
				bmpData.draw(mc);
				frames.push(bmpData);
			}
			return frames;
		}
		
		private function organizeCards(evt:MouseEvent=null):void
		{
			var spacingX:uint = 300;
			var spacingY:uint = 300;
			
			
			for(var i:uint=0; i < _planes.length; i++)
			{
//				Tweener
			}
		}
		
		private function handleStageResize(evt:Event=null):void
		{
			_scene.x = stage.stageWidth/2;
			_scene.y = stage.stageHeight/2;
			_scene.x -= _scene.x % 2;
			_scene.y -= _scene.y % 2;
		}
		
		private function getFPS(evt:Event=null):void
		{
			_currentFPS 	= Math.ceil(1000/(getTimer() - _renderTime));
			_renderTime 	= getTimer();
			
			if(!_fpsArray) _fpsArray = new Array();
			if(_fpsArray.length >= 30) _fpsArray.splice(0,1);
			_fpsArray.push(_currentFPS);
			
			//trace(_fpsArray.length);
			
			var average:uint = 0;
			for(var i:uint=_fpsArray.length-1; i >0; i--)
			{
				average += _fpsArray[i];
			}
			
			_averageFPS = Math.round(average / _fpsArray.length);
			
			if(_fpsTxt)  _fpsTxt.text 	= String(_averageFPS);
		}
		
		private function addFPSDisplay():void
		{
			_fpsTxt 					= new TextField();
			_fpsTxt.autoSize 			= "left";
			_fpsTxt.backgroundColor 	= 0x000000;
			_fpsTxt.defaultTextFormat 	= new TextFormat("_sans", 50, 0xFFFFFF);
			_fpsTxt.visible				= true;
			this.addChild(_fpsTxt);
		}
	}
}
