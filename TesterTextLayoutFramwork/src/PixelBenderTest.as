package {
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.net.*;
	import flash.system.System;
	import flash.text.TextField;
	
	public class PixelBenderTest extends Sprite
	{
		[Embed("../assets/MetaBlobs.pbj", mimeType="application/octet-stream")]
		private var Metablobs:Class;
		
		// I wonder if...
		// [Embed("some.swf", mimeType="whatevermimettype-swfs-are")]
		// private var mSWF:Class;
		
		private var im:Bitmap;
		private var imd:BitmapData;
		
		public function PixelBenderTest()
		{
			init();
		}
		
		private function init():void
		{
			trace("Ready:", System.vmVersion);
//			var shader:Shader = new Shader(new Metablobs() as ByteArray);
			
			var txt:TextField = new TextField();
			txt.getTextFormat();
		}
	}
}
