package com.paperclipped.templates
{
	import flash.display.Sprite;

	public class MainClass extends Sprite
	{
		
		public function MainClass()
		{

			init();
		}
		
		private function init():void
		{
			//_data = SiteData.getInstance(); // shoule be nmade in site controller.
			// Site Controller,
			// Site View, then addChild, then pass to controller.
			/*_data.main = this;*/
		}
	}
}