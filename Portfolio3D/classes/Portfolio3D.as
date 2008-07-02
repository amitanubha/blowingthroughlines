package {
	import com.paperclipped.portfolio.controller.SiteController;
	import com.paperclipped.portfolio.model.SiteData;
	
	import flash.display.Sprite;
	
	[SWF(backgroundColor="#000000", width="960", height="550", frameRate="60")]
	public class Portfolio3D extends Sprite
	{
		private var _controller		:SiteController;
		private var _data			:SiteData;
		
		public function Portfolio3D()
		{
			
			_data 			= SiteData.getInstance();
			_controller 	= SiteController.getInstance();
			_data.main		= this;
			init();
		}
		
		public function init():void
		{
			trace("started things in motion");
		}
	}
}
