package {
	import flash.display.Sprite;
	import flash.system.System;

	public class TesterTextLayoutFramwork extends Sprite
	{
		[Embed("../assets/MetaBlobs.pbj", mimeType="application/octet-stream")]
		private var Metablobs:Class;
		
		// I wonder if...
		// [Embed("some.swf", mimeType="whatevermimettype-swfs-are")]
		// private var mSWF:Class;
		
		public function TesterTextLayoutFramwork()
		{
			init();
		}
		
		private function init():void
		{
			trace("Ready:", System.vmVersion);
			var filterTest:
		}
	}
}
