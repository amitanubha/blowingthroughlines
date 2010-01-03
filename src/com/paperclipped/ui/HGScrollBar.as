package com.paperclipped.ui
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	public class HGScrollBar extends Sprite
	{
		
		public static const VERTICAL:String = "v";
		public static const HORIZONTAL:String = "h";
		
		private var _colorBar		:uint;
		private var _colorHandle	:uint;
		private var _colorArrow		:uint;
		private var _colorArrowBG	:uint;
		private var _isArrows		:Boolean	= true;
		private var _length			:Number;
		private var _width			:Number;
		private var _gripper		:Shape;
		
		
		// recycled vars
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
		private var _barOffSet			:Number;
				
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
		public function get barMask()	:*				{	return _mask;		}
		public function get barWidth()	:Number			{	return _width;		}
		public function get barLength()	:Number			{	return _length;		}
		
		
		// setters
		public function set content(value:DisplayObject):void	{
																	// do suhten'
																	update();
																}
														
		public function set window(value:Rectangle):void		{
																	// do whatevah
																}
												
		public function set arrows(value:Boolean):void			{
																	_isArrows = value;
																	update();
																}											
													
		public function set gripper(val:Shape):void
																{
																	if(_gripper)this.removeChild(_gripper);
																	_gripper	= val;
																	this.addChild(_gripper);
																	update();
																}										
		
		
		public function set barMask(mask:Shape):void
																{
																	if(_mask && _mask.parent)this.removeChild(_mask);
																	_mask = mask;
																	this.addChild(mask)
																	_bar.mask	= mask;
																	update();
																}
													
		public function set arrowGraphic(graphic:DisplayObject):void
																{
																	_arrowL	= graphic;
																	_arrowR	= graphic;
																	update();	
																}
		
		public function set handleGraphic(graphic:DisplayObject):void
																{
																	_handle.graphics.clear();
																	_handle.addChildAt(graphic, 0);
																	update();	
																}
																
																
		public function set barGraphic(graphic:DisplayObject):void
																{
																	_bar.graphics.clear();
																	_bar.addChildAt(graphic, 0);
																	update();		
																}
																
																
		public function set direction(val:String):void	{	
															val = val.toLowerCase();
															if(val == "h" || val == "v")
															{
																_direction = val;
																
																if(_direction == "v"){
																 	_handle.x = 0;
																 	this.rotation = 90;
																 	this.scaleY	= -1;
																 	this.scroll();
																 	this.updateLoc()
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
														
		public function set ScrollBarLength(val:Number):void	{	_length	= val;
																	this.update();
																}
		
		
		
		public function set barLength(val:Number):void		{
															_bar.width 		= val;
															_bar.scaleY 	= 1;
															_arrowR.x		= val;
															_length			= val;
															this.update();
														}
														
		public function set barWidth(val:Number):void		{ // same as barLength, to keep from killing legacy projects
															_bar.width 		= val;
															_bar.scaleY 	= 1;
															_arrowR.x		= val;
															_width			= val;
															this.update();
														}
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
			_scrollLoc				= ratio;
		}
		public function get scrollToPosition():Number
		{
			return					_scrollLoc;
		}
		
		
												
		//NOTE: set a mask to override the insivible hit area for the handle
		public function HGScrollBar(cont:DisplayObject, win:Rectangle, scrollWidth:Number=18):void
		{	
			_content 			= cont;
			_window 			= win;
			_width				= scrollWidth;
//			_color				= color;
//			_allowScrollWheel	= asw;
			
//			trace("color",_color)
			
			_bar 				= makeBar(_width);
			_bar.addEventListener(MouseEvent.CLICK, handleBar);
			
//			_mask	= new Shape();
//			_mask.graphics.beginFill(0x0);
//			_mask.graphics.drawRect(0, 0, _bar.width, _bar.height);
			
			_direction 			= HGScrollBar.HORIZONTAL;
			_respond 			= false;
			
			_isArrows			= true;
			_arrowR 			= addArrow()
			_arrowR.x 			= _bar.width;
			_arrowR.y			= Math.round(_bar.height/2 - _arrowR.height/2);
			_arrowL 			= addArrow()
			_arrowL.scaleX 		= -1;
			_arrowL.x			= _arrowL.width;
			_arrowL.y			= Math.round(_bar.height/2 - _arrowL.height/2);
			
			_arrowR.buttonMode 		= _arrowL.buttonMode 		= true;
			_arrowR.mouseChildren 	= _arrowL.mouseChildren 	= true;
			
			_arrowR.addEventListener(MouseEvent.MOUSE_DOWN, handleArrowDown);
			_arrowL.addEventListener(MouseEvent.MOUSE_DOWN, handleArrowDown);
			
			_arrowR.addEventListener(MouseEvent.MOUSE_UP, 	handleArrowUp);
			_arrowR.addEventListener(MouseEvent.MOUSE_OUT, 	handleArrowUp);
			_arrowL.addEventListener(MouseEvent.MOUSE_UP, 	handleArrowUp);
			_arrowL.addEventListener(MouseEvent.MOUSE_OUT, 	handleArrowUp);
			
			_handle 				= makeBar(_bar.height);
//			_handleOriginalHeight	= _handle.height;
//			_handle.y				= Math.round(_bar.height/2 - _handleOriginalHeight/2 );
//			_handle.x				= Math.round(_bar.height/2 - _handle.height/2 );
			var handleHitArea:Sprite = new Sprite();
				handleHitArea.graphics.beginFill( 0xffffff, 0 );
				handleHitArea.graphics.drawRect( 0, -_bar.height/2 + _handleOriginalHeight/2, _handle.width, _bar.height )
				handleHitArea.graphics.endFill();
			_handle.addChild( handleHitArea );
			
//			Set length if not already set
			if(!_length){_length	= _bar.width+_arrowL.width+_arrowR.width;}
			
			this.addChild(_bar);
			this.addChild(_handle);
			this.addChild(_arrowL);
			this.addChild(_arrowR);
			
			_scrollTimer = new Timer(30, 0);
			_scrollTimer.addEventListener(TimerEvent.TIMER, handleScrollTimer);
			init();
		}
		
		private function init():void
		{
			// do the aqua-boogy
			_handle.buttonMode 		= true;
			_handle.mouseChildren 	= false;
			this.tabEnabled 		= false;
			this.tabChildren 		= false;
			_scrollLoc 				= 0;
			this.update();
			this.scroll();
			this.updateLoc();
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, handleDown	);
			_handle.addEventListener(MouseEvent.MOUSE_UP,	handleUp	);
//			this.addEventListener(Event.ADDED_TO_STAGE, 	handleAdded	);
			
		}
		
		
		public function update(evt:Event=null):void
		{
//			if content fits in scroll area remove arrows and set handle to 100%
			
			
//			remove arrows if set to disable & adjust arrows and bar
			if(_isArrows){
				_arrowR.visible 	= true;
				_arrowR.x			= bar.x + _bar.width;
				_arrowL.visible 	= true;
				_arrowL.x			= 0+_arrowL.width
				_bar.width			= _length - _arrowL.width - _arrowR.width;
				_barOffSet	= _arrowL.width;
			}else{
				_bar.width			= _length;
				_arrowR.visible 	= false;
				_arrowL.visible 	= false;
				_barOffSet			= 0;
			}
			_bar.x				= _barOffSet;
			if(_mask)
			{
				_mask.x				= _barOffSet;
				_mask.width			= _bar.width;
				_mask.height		= _width;
			}
			
//			if(_gripper)_gripper.x	= (_gripper.width+_handle.width)/2;
				
			_arrowR.x		= _bar.width + _bar.x;
			_handle.x		= _barOffSet;
			
			//trace(this._direction);
			if(this._direction == HGScrollBar.HORIZONTAL)
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
			
			
			_handle.width 						= Math.round(_bar.width * _contentRatio);
			_handle.scaleY 						= 1;
//			if(_respond)
//			{
//				this.updateLoc();
//			}else
//			{
				// to move the handle when the bar length changes...
//				_handle.x = _scrollLoc * (_bar.width - _handle.width);
				// to move the content with the update
			this.scroll();

			if(_handle.width >= _bar.width)
			{
				// don't show?
				_handle.width 					= _bar.width;
				_handle.visible 				= false;
				_bar.visible 					= false;
				if(_gripper)_gripper.visible	= false;
				if(_arrowR && _isArrows) _arrowR.visible 	= false;
				if(_arrowL && _isArrows) _arrowL.visible 	= false;
			}else
			{
				_handle.visible 				= true;
				_bar.visible 					= true;
				if(_arrowR && _isArrows) _arrowR.visible 	= true;
				if(_arrowL && _isArrows) _arrowL.visible 	= true;
				if(_gripper)_gripper.visible	= true;
			}
			
//			}
		}
		
		
		// NOTICE: This function is broken!!! Partly. ** I think I fixed this, needed to update loc on change direction
		private function updateLoc():void
		{
			
			if(this._direction == HGScrollBar.HORIZONTAL)
			{
				_handle.x			=  -Math.round((_content.x- _window.x) / _scrollRatio)+_barOffSet;
			}else{
				_handle.x			=  -Math.round((_content.y- _window.y) / _scrollRatio)+_barOffSet;
			}
			
//			if(_gripper)_gripper.x	= (_gripper.width+_handle.width)/2;
			
//			_handle.x			=  -Math.round((_content.x- _window.x) / _scrollRatio);
			if( _bar.width != _handle.width)
			{
				_scrollLoc = _handle.x / (_bar.width - _handle.width); //ALERT: if _bar.width == _handle.width, you will be dividing by 0 <--returns NaN
			}else{
				_scrollLoc = 1;
			}
		}
		
		public function scroll(evt:MouseEvent=null):void
		{
			if(_direction == HGScrollBar.HORIZONTAL)
			{
				if(_content.width >= _handle.width * _scrollRatio)
				{
					_content.x 			= -Math.round((_handle.x-_barOffSet) * _scrollRatio) + _window.x;
				}
			}else
			{
				if(_content.height >= _handle.width * _scrollRatio)
				{
					_content.y 			= -Math.round((_handle.x-_barOffSet) * _scrollRatio) + _window.y;
				}
			}
			
			if( _bar.width != _handle.width){
				_scrollLoc = (_handle.x-_barOffSet) / (_bar.width - _handle.width);
			}else{
				_scrollLoc = 0;
			}
			
			if(_gripper)_gripper.x	= (_handle.width-_gripper.width)/2+_handle.x;
		}
		
		private function handleDown(evt:MouseEvent):void
		{
			// add mouse move event
			var offsetY:Number		= Math.round(_bar.height/2 - _handleOriginalHeight/2);
//			var offsetY:Number		= Math.round(_bar.height/2 - _handle.height/2);
//			var offsetY:Number		= 0;
			_handle.startDrag(false, new Rectangle(_barOffSet, offsetY, _bar.width - (_handle.width), 0));
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
				myBar.name	= "graphic";
//				myBar.graphics.clear();
				
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
		
		public function scrollTo(amt:Number):void
		{
			_handle.x += amt;
			_handle.x = Math.round(_handle.x);
			if(_handle.x < _barOffSet) _handle.x = _barOffSet;
			if(_handle.x >= _bar.width - _handle.width+_barOffSet) _handle.x = _bar.width - _handle.width+_barOffSet;
			this.scroll();
		}
		
//		private function handleAdded(evt:Event):void
//		{
//			MacMouseWheel.setup(stage);
//			_content.addEventListener(MouseEvent.MOUSE_WHEEL, handleWheel);
//			this.addEventListener(Event.REMOVED_FROM_STAGE, handleRemoved);
//		}
//		
//		private function handleRemoved(evt:Event):void
//		{
//			// still not sure if this is needed, was fixing another problem when i tried this...
//			_content.removeEventListener(MouseEvent.MOUSE_WHEEL, handleWheel);
//		}
		
	}
}