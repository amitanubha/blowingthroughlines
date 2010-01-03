package com.paperclipped.utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	public class AverageFPS extends Sprite
	{
		private var _averageFPS:uint;
		private var _fpsTxt:TextField;
		private var _currentFPS:Number;
		private var _renderTime:Number;
		private var _fpsArray:Array;
		private var _memTxt:TextField;
		
		public function AverageFPS()
		{
			_fpsArray = new Array();
			addFPSDisplay();
			addMemoryDisplay();
			this.buttonMode 	= true;
			this.tabChildren 	= false;
			this.tabEnabled		= false;
			this.addEventListener(Event.ENTER_FRAME, getFPS);
			this.addEventListener(MouseEvent.CLICK, garbageCollect);
			trace("added fps meter");
		}
		
		private function getFPS(evt:Event):void
		{
			_currentFPS 	= Math.ceil(1000/(getTimer() - _renderTime));
			_renderTime 	= getTimer();
			
			if(_fpsArray.length >= 30) _fpsArray.splice(0,1);
			_fpsArray.push(_currentFPS);
			
			//trace(_fpsArray.length);
			
			var average:uint = 0;
			for(var i:uint=_fpsArray.length-1; i >0; i--)
			{
				average 	+= _fpsArray[i];
			}
			
			_averageFPS 	= average / _fpsArray.length;
			
			_fpsTxt.text 	= String(_averageFPS);
			_memTxt.text	= String(Math.round(((flash.system.System.totalMemory/1024)/1024)*100)/100)+"\tMB";
		}
		
		private function garbageCollect(evt:Event):void
		{
			System.gc();
		}
		
		private function addFPSDisplay():void
		{
			_fpsTxt 					= new TextField();
			_fpsTxt.autoSize 			= "left";
			_fpsTxt.backgroundColor 	= 0x000000;
			_fpsTxt.background			= true;
			_fpsTxt.defaultTextFormat 	= new TextFormat("_sans", 50, 0xFFFFFF);
			this.addChild(_fpsTxt);
		}
		
		private function addMemoryDisplay():void
		{
			_memTxt 					= new TextField();
			_memTxt.autoSize 			= "left";
			_memTxt.backgroundColor 	= 0x000000;
			_memTxt.background			= true;
			_memTxt.defaultTextFormat 	= new TextFormat("_sans", 12, 0xFFFFFF);
			_memTxt.y 					= 50;
			this.addChild(_memTxt);
		}
		
	}
}