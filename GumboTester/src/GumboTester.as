package {
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;

	[SWF(width='800', height='600')]
	public class GumboTester extends Sprite
	{
		private var ner:Sprite;
		private var ner2:Sprite;
		private var ner3:Sprite;
		
		public function GumboTester()
		{
			this.transform.perspectiveProjection.projectionCenter = new Point(-1,-1); // top left corner
			this.transform.perspectiveProjection.fieldOfView = 150;
//			this.transform.perspectiveProjection.focalLength = 
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			ner = new Sprite();
			ner.graphics.lineStyle(0, 1);
			ner.graphics.moveTo(0,-50);
			ner.graphics.lineTo(0, 50);
			ner.graphics.moveTo(-50,0);
			ner.graphics.lineTo(50,0);
//			ner.rotationZ = 0; // this kills it!
			this.addChild(ner);
			ner.addEventListener(Event.ENTER_FRAME, handleFrame);
			
			var nerMatrix:Matrix = new Matrix();
			nerMatrix.createGradientBox(100,100, 0, -50, -50);
			
			ner2 = new Sprite();
			ner2.graphics.beginGradientFill(GradientType.LINEAR, [0xffffff, 0], [0,1], [0,255], nerMatrix);
			ner2.graphics.drawRect(-50,-50,100,100);
			ner2.rotationX = 90;
			ner2.rotationY = 90;
			ner2.z = 50;
			//ner2.graphics.
			ner.addChild(ner2);
			
			ner3 = new Sprite();
			ner3.graphics.beginGradientFill(GradientType.LINEAR, [0xffffff, 0], [0,1], [0,255], nerMatrix);
			ner3.graphics.drawRect(-50,-50,100,100);
//			ner3.graphics.b
//			ner3.rotationX = 90;
			ner3.rotationY = 90;
			ner3.z = 50;
//			ner3.rotationZ = 45;
			ner.addChild(ner3);
		}
		
		private function handleFrame(evt:Event):void
		{
			ner.x = this.mouseX;
			ner.y = this.mouseY;
		}
	}
}
