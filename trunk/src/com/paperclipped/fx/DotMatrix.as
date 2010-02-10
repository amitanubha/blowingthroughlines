package com.paperclipped.fx
{
	import fl.motion.ColorMatrix;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class DotMatrix extends Sprite
	{
		private var _animated		:Boolean;
		private var _bgColor		:Number;
		private var _bmpData		:BitmapData;
		private var _clippingRect	:Rectangle;
		private var _display		:Sprite;
		private var _dotRadius		:Number;
		private var _dotDiameter	:Number;
		private var _glow			:Bitmap;
		private var _target			:DisplayObject;
		
		//TODO: Add getters and setters for most of this.
		
		public function DotMatrix(target:DisplayObject, dotRadius:Number=2.5, glow:Boolean=true, animated:Boolean=true, bgColor:uint=0x0, clippingRect:Rectangle=null)
		{
			_animated = animated;
			_clippingRect = (clippingRect) ? clippingRect : new Rectangle();
			_display = new Sprite();
			_dotRadius = dotRadius;
			_dotDiameter = _dotRadius * 2;
			_glow = (glow) ? new Bitmap() : null;
			_target = target;		
			init();
		}
		
		private function init():void
		{
			
			this.addChild(_display);
//			_bmpData = new BitmapData(_target.width, _target.height, false, _bgColor);
//			_bmpData.draw(tester);
			
//			this.x = tester.x;
//			this.y = tester.y;
			
			if(_glow)
			{
				_display.alpha = 0.7; // for better glow through effect.
				_glow.filters = [new BlurFilter(10, 10, 3), new ColorMatrixFilter(applyColor(700, -255))];
				this.addChildAt(_glow, 0); // used because of lde visiblity effect desired...
			}	
			
			if(_animated)
				this.addEventListener(Event.ENTER_FRAME, handleFrame, false, 0, true);
			else
				handleFrame();
		}
		
		
		
		private function handleFrame(evt:Event=null):void
		{
		//	var time:Number = flash.utils.getTimer();
			update();
			
		//	trace("drawn in:", time-flash.utils.getTimer());
		}
		
		private function applyColor(contrast:int, brightness:int):Array {
			var color:ColorMatrix = new ColorMatrix();
			color.SetContrastMatrix(contrast);
			color.SetBrightnessMatrix(brightness)
			return color.GetFlatArray();
		}
		
		/**
		 * Gets the center point of the nearest dot.
		 * 
		 * @param x Horizontal coordinate to find.
		 * @param y	Vertical coordinate to find.
		 * 
		 */		
		public function getDotPoint(x:Number, y:Number):Point
		{
			// FIXME: Finish and test me!!!
			return new Point(x - (x % _dotRadius), y - (y % _dotRadius));
		}
		
		/**
		 * Re-draws the Dot Matrix effect.
		 */		
		public function update():void
		{
			_bmpData = new BitmapData(_target.width, _target.height, false, _bgColor);
			_bmpData.draw(_target);
			
			_display.graphics.clear();
			
			var col:int = _bmpData.width - _dotDiameter;
			while(col > 0)
			{
				var row:int = _bmpData.height - _dotDiameter;
				while(row > 0)
				{
					//trace("doing row", bmpData.getPixel(col, row));
					_display.graphics.beginFill(_bmpData.getPixel(col, row));
					_display.graphics.drawCircle(col, row, _dotRadius);
					_display.graphics.endFill();
					row -= _dotDiameter;
				}
				col -= _dotDiameter;
			}
			
			if(_glow)
			{
				var glowData:BitmapData = new BitmapData(_display.width, _display.height, true, 0x0);
				glowData.draw(_display);
				_glow.bitmapData = glowData;
				trace("updated glow")
			}
		}
	}
}