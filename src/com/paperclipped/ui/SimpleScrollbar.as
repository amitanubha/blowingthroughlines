package com.paperclipped.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class SimpleScrollbar extends Sprite
	{
//-------------------------------------- VARIABLES ------------------------------------------
		protected var _color:Number;
		protected var _handle:Sprite;
		protected var _ratio:Number;
		protected var _rect:Rectangle;
		protected var _dragRect:Rectangle;
		protected var _scrollHeight:int;
		protected var _target:DisplayObject;
		protected var _track:Sprite;
//-------------------------------------------------------------------------------------------

//--------------------------------------- GETTERS -------------------------------------------
		override public function get scrollRect():Rectangle			{ return _rect;			}
//-------------------------------------------------------------------------------------------

//--------------------------------------- SETTERS -------------------------------------------
		override public function set scrollRect(value:Rectangle):void	{
			_rect = value;
			update();
		}
//-------------------------------------------------------------------------------------------

//------------------------------------- PUBLIC FUNCTIONS ------------------------------------
		// Constructor
		public function SimpleScrollbar(target:DisplayObject, scrollRect:Rectangle, color:uint=0x888888)
		{
			_target = target;
			_rect	= scrollRect;
			init();
		}
		
		public function update():void
		{
			_scrollHeight 	= Math.ceil(_target.height);
			_ratio 			= _rect.height / _scrollHeight;
			if(_ratio < 1)
			{
				_handle.scaleY 	= _ratio;
				_dragRect		= new Rectangle(0, 0, 0, _rect.height - _handle.height);
				this.visible = true;
			}else
			{
				trace("the ratio is:", _ratio);
				_target.y = 0;
				this.visible = false;
			}
		}
//-------------------------------------------------------------------------------------------

//------------------------------------ PRIVATE FUNCTIONS ------------------------------------
		protected function init():void
		{
			//TODO init stuff
			_handle = handle();
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, handleHandleDown, false, 0, true);
			this.addChild(_handle);
			
			trace("built the handle", _handle.buttonMode);
			
			_track = track();
			_track.addEventListener(MouseEvent.MOUSE_DOWN, handleTrackDown, false, 0, true);
			this.addChildAt(_track, 0);
			
			// adds scroll wheel
			_target.addEventListener(MouseEvent.MOUSE_WHEEL, handleWheel, false, 0, true);
			
			update();
		}
		
		protected function handle():Sprite
		{
			var h:Sprite = new Sprite();
			h.graphics.beginFill(_color, 0.6);
			h.graphics.drawRoundRect(0, 0, 16, _rect.height, 10);
			h.graphics.endFill();
			h.scale9Grid = new Rectangle(5, 5, 10, _rect.height-10);
			h.buttonMode = true;
			return h;
		}
		
		protected function track():Sprite
		{
			var tr:Sprite = new Sprite();
			tr.graphics.beginFill(_color, 0.2);
			tr.graphics.drawRoundRect(0, 0, 16, _rect.height, 10);
			tr.graphics.endFill();
			tr.scale9Grid = new Rectangle(5, 5, 10, _rect.height-10);
			return tr;
		}
//-------------------------------------------------------------------------------------------


//-------------------------------------- EVENT HANDLERS -------------------------------------
		protected function handleHandleDown(evt:MouseEvent):void
		{
			trace("mouse down on scrollbar");
			_handle.startDrag(false, _dragRect);
			_handle.addEventListener(MouseEvent.MOUSE_MOVE, handleHandleMove, false, 0, true);
			_handle.addEventListener(MouseEvent.MOUSE_UP, handleHandleUp, false, 0, true);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleHandleMove, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleHandleUp, false, 0, true);
		}
		
		protected function handleHandleUp(evt:MouseEvent):void
		{
			_handle.stopDrag();
			_handle.removeEventListener(MouseEvent.MOUSE_MOVE, handleHandleMove);
			_handle.removeEventListener(MouseEvent.MOUSE_UP, handleHandleUp);
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleHandleMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, handleHandleUp);
		}
		
		// TODO: Move the content based on enterFrame, and add easing.		
		protected function handleHandleMove(evt:MouseEvent=null):void
		{
			_target.y = Math.floor(-(_handle.y / _ratio) + _rect.y);
		}
		
		protected function handleTrackDown(evt:MouseEvent):void
		{
			if(evt.localY < _handle.y)
				_handle.y = (_handle.y - _handle.height < 0 ) ? 0 : _handle.y - _handle.height;
			else
				_handle.y = (_handle.y + _handle.height > _track.height -_handle.height ) ? _track.height - _handle.height : _handle.y + _handle.height;
				
			handleHandleMove();
		}
		
		protected function handleWheel(evt:MouseEvent):void
		{
			_handle.y = (_handle.y - evt.delta < 0 )? 0 : (_handle.y - evt.delta > _track.height - _handle.height) ? _track.height - _handle.height : _handle.y - evt.delta;
			handleHandleMove();
		}
//-------------------------------------------------------------------------------------------

//-------------------------------- SINGLETON INSTANTIATION ----------------------------------
		
//-------------------------------------------------------------------------------------------
	}
}
