/**
 * This will be a decent (extendable basic scroll bar.
 * Works both vertically and horizontally;
 * 
 * Usage:
 * import com.paperclipped.ui.ScrollBar;
 * myScrollBar = new ScrollBar(contentToScroll, rectangleToConfineTo [custom_bar_mc, custom_handle_mc, custom_bar_mask, custom_arrow_mc]);
 * 
 * bar defaults
 */

package com.paperclipped.ui
{
	import com.pixelbreaker.ui.osx.MacMouseWheel;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	public class ScrollBar extends Sprite
	{
		public static const VERTICAL:String = "v";
		public static const HORIZONTAL:String = "h";
		
		private var _content			:DisplayObject;
		private var _window				:Rectangle;
		private var _handleLoc			:int;
		private var _direction			:String;
		private var _contentRatio		:Number;
		private var _scrollRatio		:Number;
		private var _respond			:Boolean;
		private var _scrollLoc			:Number; // this is the percentage (0 to 1) of the location of the scroll bar... (want to base it all on this actually...)
		private var _scrollTimer		:Timer;
		private var _scrollDirection	:Number;
		private var _allowScrollWheel	:Boolean;
		private var _handleOriginalHeight:Number;
		
		// visible parts
		private var _bar				:*;
		private var _handle				:*;
		private var _arrowL				:*;
		private var _arrowR				:*;
		private var _mask				:Shape;
		private var _color				:Number;
		private var _handleColor		:Number;
		private var _arrowColor			:Number;
		
		
		// gettters
		public function get bar()		:*				{	return _bar;		}
		public function get handle()	:*				{	return _handle;		}
		public function get content()	:DisplayObject	{	return _content;	}
		public function get handleLoc()	:int			{	return _handleLoc;	}
		public function get direction()	:String			{	return _direction;	}
		public function get window()	:Rectangle		{	return _window;		}
		public function get respond()	:Boolean		{	return _respond;	} // tester
		
		public function get arrowL()	:*				{	return _arrowL;		}
		public function get arrowR()	:*				{	return _arrowR;		}
		
		// setters
		public function set direction(val:String):void	{	
															val = val.toLowerCase();
															if(val == "h" || val == "v")
															{
																_direction = val;
																
																if(_direction == "v"){
																 	_handle.x = 0;
																 	this.rotation = 90;
																 	this.scroll();
																}
																
															}else
															{
																throw new Error("Need a scrollbar.direction to 'h' or 'v'");
															}
														}
		public function set respond(val:Boolean):void	{	
															_respond	= val;
															if(_respond == true)
															{
																this.addEventListener(Event.ENTER_FRAME, update);
															}else
															{
																this.removeEventListener(Event.ENTER_FRAME, update);
																//this.scroll();
															}
														} // could make it start listening only when set to true...
														
		public function set barLength(val:int):void		{
															_bar.width 		= val;
															_bar.scaleY 	= 1;
															trace("bar width:", _bar.height);
															_mask.width 	= val;
															_mask.scaleY	= 1;
															_arrowR.x		= val;
															
															this.update();
														}
														
		public function set barWidth(val:int):void		{ // same as barLength, to keep from killing legacy projects
															_bar.width 		= val;
															_bar.scaleY 	= 1;
															_mask.width 	= val;
															_mask.scaleY	= 1;
															_arrowR.x		= val;
															
															this.update();
														}
		public function set color(val:uint):void					{	_color				= val;	}
		public function set handleColor(val:uint):void				{	_handleColor		= val;	}
		public function set arrowColor(val:uint):void				{	_arrowColor			= val;	}
		public function set allowScrollWheel(val:Boolean):void		{	_allowScrollWheel	= val;	}
				
//		public function set windowWidth(val:int):void	{
//															_window.width 	= val;
//															update();
//														}


		/**
		 * Scrolls content and handle to a ratio between 0 and 1.
		 * @param ratio number from 0 to 1 that defines what position to scroll to
		 * 
		 */		
		public function set scrollToPosition( ratio:Number ):void
		{
			trace(ratio);
			_scrollLoc				= ratio;
		}
		public function get scrollToPosition():Number
		{
			return					_scrollLoc;
		}
		
		//NOTE: set a mask to override the insivible hit area for the handle
		public function ScrollBar(cont:DisplayObject, win:Rectangle, br:*=null, hand:*=null, msk:Shape=null, arrowR:*=null, arrowL:*=null, color:uint=0x333333, asw:Boolean = true):void
		{	
			_content 			= cont;
			_window 			= win;
			_color				= color;
			_allowScrollWheel	= asw;
			
			trace("color",_color)
			
			if(!br) br 			= makeBar();
			_bar 				= br;
			_bar.addEventListener(MouseEvent.CLICK, handleBar);
			
			if(!hand) hand 		= makeBar(_bar.height);
			_handle 			= hand;
			_handleOriginalHeight = _handle.height;
			_handle.y			= Math.round(_bar.height/2 - _handleOriginalHeight/2 );
//			_handle.y			= Math.round(_bar.height/2 - _handle.height/2 );
			var handleHitArea:Sprite = new Sprite();
			handleHitArea.graphics.beginFill( 0xffffff, 0 );
			handleHitArea.graphics.drawRect( 0, -_bar.height/2 + _handleOriginalHeight/2, _handle.width, _bar.height )
			handleHitArea.graphics.endFill();
			trace(_handle.y + " <<<<<<______________-");
			_handle.addChild( handleHitArea );
			
			if(!msk)
			{
				msk		= new Shape();
				msk.graphics.beginFill(0x0);
				msk.graphics.drawRect(0, 0, _bar.width, _bar.height);
			}
			_mask = msk;
			
			_direction 			= ScrollBar.HORIZONTAL;
			_respond 			= false;
			
			if(!arrowR) arrowR 	= addArrow();
			if(!arrowL) arrowL 	= addArrow();
			
			_arrowR 			= arrowR;
			_arrowR.x 			= _bar.width;
			_arrowR.y			= Math.round(_bar.height/2 - _arrowR.height/2);
			_arrowL 			= arrowL;
			_arrowL.scaleX 		= -1;
			_arrowL.y			= Math.round(_bar.height/2 - _arrowL.height/2);
			
			_arrowR.buttonMode 		= _arrowL.buttonMode 		= true;
			_arrowR.mouseChildren 	= _arrowL.mouseChildren 	= true;
			
			_arrowR.addEventListener(MouseEvent.MOUSE_DOWN, handleArrowDown);
			_arrowL.addEventListener(MouseEvent.MOUSE_DOWN, handleArrowDown);
			
			_arrowR.addEventListener(MouseEvent.MOUSE_UP, 	handleArrowUp);
			_arrowR.addEventListener(MouseEvent.MOUSE_OUT, 	handleArrowUp);
			_arrowL.addEventListener(MouseEvent.MOUSE_UP, 	handleArrowUp);
			_arrowL.addEventListener(MouseEvent.MOUSE_OUT, 	handleArrowUp);
			
			
			
			this.addChild(_bar);
			this.addChild(_handle);
			this.addChild(_mask);
			this.addChild(_arrowL);
			this.addChild(_arrowR);
			_handle.mask = _mask;
			
			_scrollTimer = new Timer(30, 0);
			_scrollTimer.addEventListener(TimerEvent.TIMER, handleScrollTimer);
			
			init();
		}
		
		private function init():void
		{
			// do the aqua-boogy
			_handle.buttonMode 		= true;
			_handle.mouseChildren 	= false;
			_scrollLoc = 1;
			this.update();
//			this.scroll();
			this.updateLoc();
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, handleDown	);
			_handle.addEventListener(MouseEvent.MOUSE_UP,	handleUp	);
			this.addEventListener(Event.ADDED_TO_STAGE, 	handleAdded	);
			
		}
		
		
		public function update(evt:Event=null):void
		{
			//trace(this._direction);
			if(this._direction == ScrollBar.HORIZONTAL)
			{
				// scale widths
				_contentRatio 		= _window.width		/ _content.width;
				_scrollRatio		= _content.width	/ _bar.width;
				
			}else
			{
				// scale heights
				_contentRatio		= _window.height	/ _content.height;
				_scrollRatio		= _content.height	/ _bar.width;
			}
			
//			trace("content holder: ", this._content.width, this._contentRatio, this._scrollRatio);
//			trace("resizing handle:", this._handle.width, ":", _bar.width);
			
			_handle.width 			= Math.ceil(_bar.width * _contentRatio); // not updating initially...
			
			if(_handle.width >= _bar.width)
			{
				// don't show?
				_handle.width 					= _bar.width;
				_handle.visible 				= false;
				_bar.visible 					= false;
				if(_arrowR) _arrowR.visible 	= false;
				if(_arrowL) _arrowL.visible 	= false;
			}else
			{
				_handle.visible 				= true;
				_bar.visible 					= true;
				if(_arrowR) _arrowR.visible 	= true;
				if(_arrowL) _arrowL.visible 	= true;
			}
			
			_handle.width 						= Math.round(_bar.width * _contentRatio);
			_handle.scaleY 						= 1;
			
			if(_respond)
			{
				this.updateLoc();
			}else
			{
				// to move the handle when the bar length changes...
				_handle.x = _scrollLoc * (_bar.width - _handle.width);
				// to move the content with the update
				this.scroll();
			}
		}
		
		
		// NOTICE: This function is broken!!! Partly.
		private function updateLoc():void
		{
			if(this._direction == ScrollBar.HORIZONTAL)
			{
				_handle.x			=  -Math.round((_content.x- _window.x) / _scrollRatio);
				
			}else
			{
				_handle.x			=  -Math.round((_content.y- _window.y) / _scrollRatio);
			}
			
//			_handle.x			=  -Math.round((_content.x- _window.x) / _scrollRatio);
			if( _bar.width != _handle.width)
				_scrollLoc = _handle.x / (_bar.width - _handle.width); //ALERT: if _bar.width == _handle.width, you will be dividing by 0 <--returns NaN
			else
				_scrollLoc = 1;
		}
		
		public function scroll(evt:MouseEvent=null):void
		{
			if(_direction == ScrollBar.HORIZONTAL)
			{
				if(_content.width > _handle.width * _scrollRatio)
				{
					_content.x 			= -Math.round(_handle.x * _scrollRatio) + _window.x;
				}
			}else
			{
				if(_content.height > _handle.width * _scrollRatio)
				{
					_content.y 			= -Math.round(_handle.x * _scrollRatio) + _window.y;
				}
			}
			
			if( _bar.width != _handle.width)
				_scrollLoc = _handle.x / (_bar.width - _handle.width);
			else
				_scrollLoc = 0;
		}
		
		private function handleDown(evt:MouseEvent):void
		{
			// add mouse move event
			var offsetY:Number		= Math.round(_bar.height/2 - _handleOriginalHeight/2);
//			var offsetY:Number		= Math.round(_bar.height/2 - _handle.height/2);
//			var offsetY:Number		= 0;
			_handle.startDrag(false, new Rectangle(0, offsetY, _bar.width - (_handle.width), 0));
			stage.addEventListener(MouseEvent.MOUSE_MOVE, 		scroll);
			stage.addEventListener(MouseEvent.MOUSE_UP, 		handleUp);
			stage.addEventListener(Event.MOUSE_LEAVE, 			handleUp);
			_respond 			= false;
		}
		
		private function handleUp(evt:Event):void
		{
			// stop mouse move event
			_handle.stopDrag();
			//_handle.x = Math.ceil(_handle.x);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, 	scroll);
			stage.removeEventListener(MouseEvent.MOUSE_UP, 		handleUp);
			stage.removeEventListener(Event.MOUSE_LEAVE, 		handleUp);
		}
		
		private function makeBar( h:Number = 18, color:Number= 0):Sprite		
		{
			var myBar:Sprite 	= new Sprite();
				myBar.graphics.beginFill(color, 0.3);
				myBar.graphics.drawRect(0,0,100,h);
				myBar.graphics.endFill();
			return myBar;
		}
		
		private function addArrow():Sprite
		{
			var arrowBtn:Sprite	= new Sprite();
			
				arrowBtn.graphics.beginFill(_color, 0.3);
				arrowBtn.graphics.drawRect(0,0,20,18);
				arrowBtn.graphics.endFill();
				arrowBtn.graphics.beginFill(_color, 0.5);
				arrowBtn.graphics.moveTo(7,6);
				arrowBtn.graphics.lineTo(7,12);
				arrowBtn.graphics.lineTo(13,9);
				arrowBtn.graphics.lineTo(7,6);
			return arrowBtn;
		}
		
		private function handleArrowDown(evt:MouseEvent):void
		{
			if(evt.currentTarget == _arrowR)
			{
				_scrollDirection = 1;
			}else
			{
				_scrollDirection = -1;
			}
			_scrollTimer.start();
		}
		
		private function handleArrowUp(evt:MouseEvent):void
		{
			_scrollDirection 	= 0;
			_scrollTimer.reset();
		}
		
		private function handleWheel(evt:MouseEvent):void
		{
			if(_allowScrollWheel)
			{
				respond 			= false;
				scrollTo(-evt.delta);
			}
		}
		
		private function handleBar(evt:MouseEvent):void
		{
			var barScale:Number = Sprite(evt.currentTarget).scaleX;
			if(evt.localX*barScale <= _handle.x)
			{
//				trace("scrolling left");
				scrollTo(-_handle.width);
			}else
			{
//				trace("scrolling right");
				scrollTo(_handle.width);
			}
		}
		
		private function handleScrollTimer(evt:TimerEvent):void
		{
			var mult:Number 	= Timer(evt.currentTarget).currentCount / 2;
			if(mult > 20) mult 	= 20;
			var scrollAmt:Number =  _scrollDirection * mult;
			this.scrollTo(scrollAmt);
		}
		
		private function scrollTo(amt:Number):void
		{
			_handle.x += amt;
			_handle.x = Math.round(_handle.x);
			if(_handle.x < 0) 								_handle.x = 0;
			if(_handle.x >= _bar.width - _handle.width) 	_handle.x = _bar.width - _handle.width;
			this.scroll();
		}
		
		private function handleAdded(evt:Event):void
		{
			MacMouseWheel.setup(stage);
			_content.addEventListener(MouseEvent.MOUSE_WHEEL, handleWheel);
			this.addEventListener(Event.REMOVED_FROM_STAGE, handleRemoved);
		}
		
		private function handleRemoved(evt:Event):void
		{
			// still not sure if this is needed, was fixing another problem when i tried this...
			_content.removeEventListener(MouseEvent.MOUSE_WHEEL, handleWheel);
		}
	}
}