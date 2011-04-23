package com.huntandgather.lda.display
{
	import caurina.transitions.Tweener;
	
	import five3D.display.Bitmap3D;
	import five3D.display.Scene3D;
	import five3D.display.Sprite3D;
	import five3D.geom.Point3D;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class Plane53D extends Sprite3D
	{
		private var _scene:Scene3D;
		private var _origin:Point3D;
		private var _bitmapData:BitmapData;
		
		public function get origin():Point3D			{	return _origin;	}
		
		
		public function set origin(val:Point3D):void	{	_origin = val;	}
		public function set bitmapData(val:BitmapData):void		{
															_bitmapData = val;
															var bmp:Bitmap3D = new Bitmap3D(_bitmapData, true);
															bmp.x = -_bitmapData.width/2;
															bmp.y = -_bitmapData.height/2;
															this.addChild(bmp);
														}
		
		public function Plane53D()
		{
			super();
			init();
		}
		
		private function init():void
		{
			this.buttonMode 	= true;
			this.mouseChildren = false;
			
			this.addEventListener(Event.ADDED_TO_STAGE, handleAdded);
		}
		
		private function handleAdded(evt:Event):void
		{
			trace("added to stage");
			_scene = Scene3D(this.parent);
			this.addEventListener(MouseEvent.CLICK, 		handleClick);
			this.addEventListener(MouseEvent.MOUSE_OVER, 	handleOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, 	handleOver);
			this.addEventListener(Event.ENTER_FRAME, 		handleFrame);
		}
		
		private function handleOver(evt:MouseEvent):void
		{
			if(evt.type == "mouseOver")
			{
				this.removeEventListener(Event.ENTER_FRAME, handleFrame);
//				this.addEventListener(Event.ENTER_FRAME, handlePlaneFrame2);
				
				var toPoint:Point = this.matrix3D.getInverseCoordinates(this.matrix3D.tx, this.matrix3D.ty, this.matrix3D.tz)
				
				var toX:int = Math.round(_origin.x * (1000 / (1000 + _origin.z))); //_scene.mouseX; //Math.round(toPoint.x)
				var toY:int = Math.round(_origin.y * (1000 / (1000 + _origin.z))); //_scene.mouseY; //Math.round(toPoint.y)
				
				Tweener.addTween(this, {x:toX, 	y:toY, 	 z:0, 	alpha:1,  	rotationY:0,	time:0.5, 	transition:"easeoutquad"});
				
//				trace(this.matrix3D.tx, this.matrix3D.ty, this.matrix3D.tz);
				trace(this.matrix3D.tx, this.matrix3D.ty, this.matrix3D.getInverseCoordinates(this.matrix3D.tx, this.matrix3D.ty, this.matrix3D.tz), _scene.mouseX, _scene.mouseY	);
				
				
			}else
			{
//				this.removeEventListener(Event.ENTER_FRAME, handlePlaneFrame2);
				this.addEventListener(Event.ENTER_FRAME, handleFrame);

				Tweener.addTween(this, {x:_origin.x, 	y:_origin.y, 	z:_origin.z, 	alpha:0.6, 					time:1, 	transition:"easeoutback"});
			}
		}
		
		private function handleClick(evt:MouseEvent):void
		{
			// would tell the currently opened thing to go away if we had a SiteData...
			if(this.hasEventListener(MouseEvent.MOUSE_OVER))
			{
				this.removeEventListener(MouseEvent.MOUSE_OUT, 		handleOver);
				this.removeEventListener(MouseEvent.MOUSE_OVER, 	handleOver);
				Tweener.addTween(this, {x:0, 				y:0, 			z:0, 			alpha:1, 	rotationY:0, 	time:0.5, 	transition:"easeoutquad"});
			}else
			{
				Tweener.addTween(this, {x:_origin.x, 	y:_origin.y, 	z:_origin.z, 	alpha:0.6, 					time:1, 	transition:"easeoutback"});
				this.addEventListener(MouseEvent.MOUSE_OVER, 	handleOver);
				this.addEventListener(MouseEvent.MOUSE_OUT, 	handleOver);
				this.addEventListener(Event.ENTER_FRAME, 		handleFrame);
			}
		}
		
		private function handleFrame(evt:Event):void
		{
			var total:uint = this.parent.numChildren;
			this.rotationY 	+= 1 + (total - this.parent.getChildIndex(this));
		}
		
		private function handlePlaneFrame2(evt:Event):void
		{
			trace(this.mouseXY, this.z);
		}
		
	}
}