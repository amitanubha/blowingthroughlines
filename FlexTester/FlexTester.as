package {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	public class FlexTester extends Sprite
	{
		private var _bmp:Bitmap;
		private var _frames:Array;
		public function FlexTester()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align		= StageAlign.TOP_LEFT;
			init();
		}
		
		private function init():void
		{
			trace("tester is running");
			var ner:AnimatedPlaneMC = new AnimatedPlaneMC();
			
//			var tester:bit
			
			_bmp = new Bitmap();
			_bmp.smoothing = true;
			_bmp.pixelSnapping = PixelSnapping.ALWAYS;
			this.addChild(_bmp);

			_frames = ripFrames(ner);
			animateBMP(_frames);
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
//			trace(timer.currentCount);
			if(timer.currentCount > _frames.length)
			{
				timer.reset();
				timer.start();
			}
			_bmp.bitmapData = _frames[timer.currentCount-1];
		}
		
		private function ripFrames(mc:MovieClip):Array
		{
			var frames:Array = new Array();
			for(var i:uint=0; i < mc.totalFrames; i++)
			{
				mc.gotoAndStop(i+1);
				var bmpData:BitmapData = new BitmapData(mc.width, mc.height, true, 0xBADA55);
				trace(bmpData.height);
				bmpData.draw(mc);
				frames.push(bmpData);
			}
			return frames;
		}
	}
}
