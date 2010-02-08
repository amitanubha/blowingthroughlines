package com.paperclipped.fx
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class DoxMatrix extends Sprite
	{
		private var _animated	:Boolean;
		private var _bgColor	:Number;
		private var _bmpData	:BitmapData;
		private var _display	:Sprite;
		private var _dotRadius	:Number;
		private var _dotDiameter:Number;
		private var _glow		:Bitmap;
		private var _tester		:DisplayObject;
		
		public function DoxMatrix(testers:DisplayObject, dotRadius:Number=2.5, glow:Boolean=true, animated:Boolean=true, bgColor:uint=0x0)
		{
			_animated = animated;
			_display = new Sprite();
			_dotRadius = dotRadius;
			_dotDiameter:Number = _dotRadius * 2;
			_glow = (glow) ? new Bitmap() : null;
			_tester = testers;		
			init();
		}
		
		private function init():void
		{
			_bmpData = new BitmapData(_tester.width, _tester.height, false, bgColor);
//			_bmpData.draw(tester);
			
//			this.x = tester.x;
//			this.y = tester.y;
			
			if(_glow)
			{
				bmp.filters = [new BlurFilter(10, 10, 3), new ColorMatrixFilter(applyColor(2, 2, 2))];
				this.addChildAt(bmp, 0);
			}	
			
			if(_animated)
				this.addEventListener(Event.ENTER_FRAME, handleFrame, false, 0, true);
			else
				handleFrame();
		}
		
		private function handleFrame(evt:Event=null):void
		{
		//	var time:Number = flash.utils.getTimer();
			var col:int = _bmpData.width - _dotDiameter;
			this.graphics.clear();
			_bmpData.draw(_tester);
			while(col > 0)
			{
				var row:int = _bmpData.height - _dotDiameter;
				while(row > 0)
				{
					//trace("doing row", bmpData.getPixel(col, row));
					this.graphics.beginFill(_bmpData.getPixel(col, row));
					this.graphics.drawCircle(col, row, _dotRadius);
					this.graphics.endFill();
					row -= _dotDiameter;
				}
				col -= _dotDiameter;
			}
			
			if(_glow)
			{
				var glowData:BitmapData = new BitmapData(_display.width, _display.height, true, 0x0);
				_glow.bitmapData = glowData;
			}
			
		//	trace("drawn in:", time-flash.utils.getTimer());
		}
		
		private function applyColor(r:Number=0, g:Number=0, b:Number=0, a:Number=1):Array {
			var color:ColorMatrix = new ColorMatrix();
			color.SetContrastMatrix(700);
			color.SetBrightnessMatrix(-255)
			return color.GetFlatArray();
		}
	}
}