package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	[SWF(backgroundColor="#FFFFFF", width="800", height="600")]
	public class flash10tester extends Sprite
	{
		public function flash10tester()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align		= StageAlign.TOP_LEFT;
			this.z = 100;
			this.x = 300;
			this.y = 200;
			this.rotationX = 45;
			this.rotationY = 45;
			this.graphics.beginFill(0x0);
			this.graphics.drawRoundRectComplex(0,0,200,200,20,20,20,20);
		}
	}
}
