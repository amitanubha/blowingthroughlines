package com.paperclipped.ui
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class SimpleScrollingTextField extends Sprite
	{
//-------------------------------------- VARIABLES ------------------------------------------
		protected var _field:TextField;
		protected var _format:TextFormat;
		protected var _mask:Shape;
		protected var _scrollbar:SimpleScrollbar;
		protected var _spacing:int;
		protected var _width:int;
		protected var _height:int;
//-------------------------------------------------------------------------------------------

//--------------------------------------- GETTERS -------------------------------------------
//		public function get autoSize():
		public function get defaultTextFormat():TextFormat	{ return _field.defaultTextFormat;	}
		public function get embedFonts():Boolean			{ return _field.embedFonts;		}
		public function get format():TextFormat				{ return _format;				}
		public function get htmlText():String				{ return _field.htmlText;		}
		public function get scrollbar():SimpleScrollbar		{ return _scrollbar;			}
		public function get spacing():int					{ return _spacing;				}
		public function get styleSheet():StyleSheet			{ return _field.styleSheet;		}
		public function get text():String					{ return _field.text;			}
		public function get textField():TextField			{ return _field;				}
		public function get textMask():Shape				{ return _mask;					}
		public function get textColor():uint				{ return _field.textColor;		}
		// Overrides
		override public function get width():Number			{ return _mask.width;			} //TODO: decide how to handle the placement of the scrollbar (inside or out!!!)
		override public function get height():Number		{ return _mask.height;			}
//-------------------------------------------------------------------------------------------

//--------------------------------------- SETTERS -------------------------------------------
		public function set defaultTextFormat(val:TextFormat):void	{
			_format = val;
			_field.defaultTextFormat = _format;
//			_field.setTextFormat(_format);
			_scrollbar.update();
		}
		public function set embedFonts(val:Boolean):void		{
			_field.embedFonts = val;
			_scrollbar.update();
		}
		public function set htmlText(val:String):void			{ 
			_field.htmlText	= val;
			_scrollbar.update();
		}
		public function set spacing(val:int):void				{ 
			_spacing 	= val;
			_mask.x 	= _width + spacing;
		}
		public function set styleSheet(val:StyleSheet):void		{
			_field.styleSheet = val;
			_scrollbar.update();
		}
		public function set text(val:String):void				{ 
			_field.text		= val;
			_scrollbar.update();
		}
		public function set textColor(val:uint):void			{ _field.textColor = val;	}
		// Overrides
		override public function set width(value:Number):void	{
			_width			= value;
			_field.width 	= value;
			_mask.width 	= value;
			_scrollbar.x 	= value + _spacing;
			_scrollbar.update();
		}
		override public function set height(value:Number):void	{
			trace("?????????????????? are we setting the height ???????????????????");
			_mask.height = value;
			_scrollbar.update();
		}
//-------------------------------------------------------------------------------------------

//------------------------------------- PUBLIC FUNCTIONS ------------------------------------
		// Constructor
		public function SimpleScrollingTextField(w:int, h:int, scrollbar:SimpleScrollbar=null)
		{
			_width 		= w;
			_height 	= h;
			_scrollbar 	= scrollbar;
			_spacing 	= 3;
			init();
		}
		
		public function setTextFormat(format:TextFormat, beginIndex:int=-1, endIndex:int=-1):void
		{
			_field.setTextFormat(format, beginIndex, endIndex);
		}
		
		public function update():void
		{
			_scrollbar.update();
		}
//-------------------------------------------------------------------------------------------

//------------------------------------ PRIVATE FUNCTIONS ------------------------------------
		private function init():void
		{
			// Create mask
			_mask = new Shape();
			_mask.graphics.beginFill(0x009999);
			_mask.graphics.drawRect(0, 0, _width, _height);
			_mask.graphics.endFill();
			
			// Create _field
			_field 				= new TextField();
			_field.wordWrap 	= true;
			_field.multiline 	= true;
			_field.autoSize 	= TextFieldAutoSize.LEFT;
			_field.width		= _width;
			_field.mask 		= _mask;
			_field.antiAliasType= AntiAliasType.ADVANCED;
						
//			_field.border		= true;
//			_field.borderColor	= 0xb00b13;
			
			// Create scrollbar
			_scrollbar 		= (!_scrollbar) ? new SimpleScrollbar(_field, new Rectangle(0, 0, _width, _height)) : _scrollbar;
			_scrollbar.x 	= _width + spacing;
			_scrollbar.y	= 0;
			
			//Add it all to the stage
			this.addChild(_mask);
			this.addChild(_field);
			this.addChild(_scrollbar);
		}
//-------------------------------------------------------------------------------------------


//-------------------------------------- EVENT HANDLERS -------------------------------------
		
//-------------------------------------------------------------------------------------------

//-------------------------------- SINGLETON INSTANTIATION ----------------------------------
		
//-------------------------------------------------------------------------------------------
	}
}
