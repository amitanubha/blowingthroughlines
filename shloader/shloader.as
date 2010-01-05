package {
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class shloader extends Sprite
	{
		private var _swfLoader:Loader;
		private var _flashVars:Object;
		
		private var _textField:TextField;
		
		public function get flashVars():Object	{return _flashVars};
		
		public function shloader()
		{
			this.stage.scaleMode	= "noScale";
			this.stage.align		= "TL";
			
			
			// Load flashVars
			_flashVars	= LoaderInfo(this.root.loaderInfo).parameters;
			trace("shloader says: ", _flashVars.swf);
			
			
			var url:String	= _flashVars.swf;
			var url_request:URLRequest	= new URLRequest(url);
			// Add Loader
			_swfLoader	= new Loader();
			_swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_swfLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			_swfLoader.load(url_request);
			
			addChild(_swfLoader);
			
			var format:TextFormat	= new TextFormat(_flashVars.loaderFont, _flashVars.loaderSize, _flashVars.loaderColor);
			
			_textField	= new TextField();
				_textField.defaultTextFormat 		= format;
				_textField.autoSize 				= TextFieldAutoSize.LEFT;
				_textField.antiAliasType			= AntiAliasType.ADVANCED;
				_textField.selectable				= false;
				_textField.text						= "Loading 0%";
				_textField.x						= (this.stage.stageWidth/2)	- (_textField.width/2);
				_textField.y						= (this.stage.stageHeight/2) - (_textField.height/2);
			this.addChild(_textField);
		}
		
		private function onLoadComplete(e:Event):void
		{			
			this.removeChild(_textField);
		}
		
		private function onLoadProgress(e:ProgressEvent):void
		{
			trace("progress");
			_textField.text	= "Loading "+ String(Math.round((e.bytesLoaded/e.bytesTotal)*100))+"%";
		}
		
	}
}