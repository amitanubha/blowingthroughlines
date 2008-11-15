package {
	import example.PerpetualFall;
	
	import flash.display.Sprite;
	
	[SWF( backgroundColor="#ececed", width="800", height="600" )] 
	public class FoamTester extends Sprite
	{
		
		public function FoamTester()
		{
			stage.frameRate = 50;
			stage.scaleMode = "noScale";
			stage.align = "TL";
			init();
		}
		
		private function init():void
		{
			addChild( new PerpetualFall());
		}
	}
}
