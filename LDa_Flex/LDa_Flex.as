package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	public class LDa_Flex extends Sprite
	{
		private var tester:Sprite;
		private var myTester:Tester;
		private var linkTest:OtherTestButton;
		
		public function LDa_Flex()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 30;
			
			init();
		}
		
		private function init():void
		{
			myTester = new Tester();
			this.addChild(myTester);
			
			linkTest = new OtherTestButton();
			linkTest.x = stage.stageWidth - linkTest.width;
			linkTest.y = stage.stageHeight - linkTest.height;
			this.addChild(linkTest);
			
			tester = new Sprite();
			tester.graphics.beginFill(0x123456);
			tester.graphics.drawCircle(200,300,100);
			this.addChild(tester);
			trace("added", tester);
		}
	}
}
