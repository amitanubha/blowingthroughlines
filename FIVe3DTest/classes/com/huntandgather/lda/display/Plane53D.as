package com.huntandgather.lda.display
{
	import five3D.display.Sprite3D;
	import five3D.geom.Point3D;
	
	import flash.display.Bitmap;

	public class Plane53D extends Sprite3D
	{
		private var _origin:Point3D;
		private var _bitmap:Bitmap;
		
		public function get origin():Point3D			{	return _origin;	}
		
		public function set origin(val:Point3D):void	{	_origin = val;	}
		public function set bitmap(val:Bitmap):void		{
															_bitmap = val;
															this.addChild(_bitmap);
														}
		
		public function Plane53D()
		{
			super();
			init();
		}
		
		private function init():void
		{
			
		}
	}
}