package {
	import caurina.transitions.Tweener;
	
	import com.huntandgather.lda.display.Plane53D;
	
	import five3D.display.Scene3D;
	import five3D.geom.Point3D;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
			for( var i:uint=0; i < 30; i++)
			{
				var plane:Plane53D 	= new Plane53D();
				var w:Number 		= 200; //Math.round(Math.random()*100)+200;
				var h:Number 		= 200; //Math.round(Math.random()*100)+200;
				
				w -= w%2;
				h -= h%2;
				
				var planeGraphics:Sprite = new Sprite();
				plane.graphics3D.beginFill(0xBADA55, 1);
				plane.graphics3D.drawRoundRect(-w/2, -h/2, w, h, 20, 20);
				
				plane.alpha 		= 0.6;
				plane.x 			= Math.round((Math.random()*stage.stageWidth)-stage.stageWidth/2);
				plane.y 			= Math.round((Math.random()*stage.stageHeight)-stage.stageHeight/2);
				plane.z 			= Math.round(Math.random()*3000);
				
				plane.origin 		= new Point3D(plane.x, plane.y, plane.z);
				
				plane.buttonMode 	= true;
				plane.mouseChildren = false;
				plane.addEventListener(MouseEvent.MOUSE_OVER, handlePlaneOver);
				plane.addEventListener(MouseEvent.MOUSE_OUT, handlePlaneOver);
				
				plane.addEventListener(Event.ENTER_FRAME, handlePlaneFrame);

				_scene.addChild(plane);
				_planes.push(plane);
			}
		}
		
		private function handlePlaneOver(evt:MouseEvent):void
		{
			var plane:Plane53D = Plane53D(evt.currentTarget);
			if(evt.type == "mouseOver")
			{
				plane.removeEventListener(Event.ENTER_FRAME, handlePlaneFrame);
				plane.addEventListener(Event.ENTER_FRAME, handlePlaneFrame2);
				plane.rotationY = 0;
				
				Tweener.addTween(plane, {x:_scene.mouseX, 	y:_scene.mouseY, 	z:0, 				alpha:1,  	time:1, 	transition:"easeoutback"});
			}else
			{
				plane.removeEventListener(Event.ENTER_FRAME, handlePlaneFrame2);
				plane.addEventListener(Event.ENTER_FRAME, handlePlaneFrame);

				Tweener.addTween(plane, {x:plane.origin.x, 	y:plane.origin.y, 	z:plane.origin.z, 	alpha:0.6, 	time:1, 	transition:"easeoutback"});
			}
		}
		
		private function handlePlaneFrame(evt:Event):void
		{
			var plane:Plane53D 	= Plane53D(evt.currentTarget);
			plane.rotationY 	+= Math.round(Math.random()*30);
		}
		
		private function handlePlaneFrame2(evt:Event):void
		{
			trace(evt.target.mouseXY, evt.target.z);
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
