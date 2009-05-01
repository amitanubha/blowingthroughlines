package {
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class TransformMatrixTester extends Sprite
	{
		private var square:Sprite;
		private var _angle:Number;
		
		public function TransformMatrixTester()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 30;
			_angle = 0;
			init();
		}
		
		private function init():void
		{
			square = makeSquare();	
			square.addEventListener(Event.ENTER_FRAME, handleFrame);
			
			square.x = 100;
			square.y = 100;
			
//			square.transform.matrix.translate(100,100);
			this.addChild(square);
		}
		
		private function makeSquare():Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0xc07712);
			s.graphics.drawRect(0,0,100,100);
			s.graphics.endFill();
			s.graphics.beginFill(0x5ea2fc);
			s.graphics.drawRect(50,0,50,50);
			s.graphics.drawRect(0,50,50,50);
			
			return s;
		}
		
		private function handleFrame(evt:Event):void
		{
			var mat:Matrix = square.transform.matrix;
			mat.rotate(0.0174532925);
			var ner:Point = mat.transformPoint(new Point(50,50));
			//mat.translate(ner.x, ner.y);
			
			square.transform.matrix.rotate(0.5);
		}
	}
}
