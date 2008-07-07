package {
	import com.huntandgather.lda.display.Plane53D;
	
	import five3D.display.Scene3D;
	import five3D.display.Shape3D;
	import five3D.geom.Point3D;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
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
		
		public function FIVe3DTest()
		{
			stage.frameRate = 30;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align		= StageAlign.TOP_LEFT;
			trace("five3D exists");
			flash.utils.setTimeout(init, 1000);
		}
		
		private function init():void
		{
			trace("running the init function");
			_scene 	= new Scene3D();
			_planes = new Array();
			_scene.x = Math.round(stage.stageWidth/2);
			_scene.y = Math.round(stage.stageHeight/2);
			_scene.addEventListener(Event.ENTER_FRAME, setChildIndecies);
			
			
			populateScene();
			this.addChild(_scene);
			
			addFPSDisplay();
			this.addEventListener(Event.ENTER_FRAME, getFPS);
			
			
//			var tester:Sprite = new Sprite();
//			tester.graphics.beginFill(0x123456, 0.4);
//			tester.graphics.drawRoundRect(-100, -100, 200, 200, 20, 20);
//			tester.x = Math.round(stage.stageWidth/2);
//			tester.y = Math.round(stage.stageHeight/2);
//			tester.x += tester.x%2;
//			tester.y += tester.y%2;
//			tester.mouseEnabled = false;
//			this.addChild(tester);
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
			
//			var line:Shape3D = new Shape3D();
//			line.graphics3D.lineStyle(3, 0xcc0000, 0.7); 
//			line.graphics3D.moveToSpace(1000, plane.y * (1/2.5), 0);
//			line.graphics3D.lineToSpace(plane.x, plane.y, plane.z);
//			_scene.addChild(line);
//			
//			var dot:Shape3D = new Shape3D();
//			dot.graphics3D.beginFill(0x00CC00, 0.4);
//			dot.graphics3D.drawCircle(0,0,9);
//			_scene.addChildAt(dot, 0);
		}
		
		private function setChildIndecies(evt:Event/* scene:Scene3D */):void
		{
			var scene:Scene3D 	= Scene3D(evt.currentTarget);
			var planes:Array	= new Array();
			for(var i:uint=0; i < scene.numChildren; i++)
			{
				var plane:Plane53D = Plane53D(scene.getChildAt(i));
				planes.push(plane);
			}
			
			planes.sortOn("z", Array.NUMERIC | Array.DESCENDING);
			
			for(var k:uint=0; k < planes.length; k++)
			{
				scene.setChildIndex(Plane53D(planes[k]), k);
			}
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
			
			_averageFPS = average / _fpsArray.length;
			
			/* if(_showFPS)   */_fpsTxt.text 	= String(_averageFPS);
		}
		
		private function addFPSDisplay():void
		{
			_fpsTxt 					= new TextField();
			_fpsTxt.autoSize 			= "left";
			_fpsTxt.backgroundColor 	= 0x000000;
			_fpsTxt.defaultTextFormat 	= new TextFormat("_sans", 50, 0xFFFFFF);
			_fpsTxt.visible				= false;
			this.addChild(_fpsTxt);
		}
	}
}
