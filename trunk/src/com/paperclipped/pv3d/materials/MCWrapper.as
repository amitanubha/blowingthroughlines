package com.paperclipped.pv3d.materials
{
	import flash.display.MovieClip;

	public class MCWrapper extends MovieClip
	{
		public function MCWrapper()
		{
			// constructor
		}
		
		public function animateFrame(value:int=1):void	{ 
			this.gotoAndPlay(value); 
			trace("animateFrame "+value)
		}
		public function stopFrame(value:int=1):void		{ this.gotoAndStop(value); }
		
		public function get current():int		{ return this.currentFrame;}
		
	}
}