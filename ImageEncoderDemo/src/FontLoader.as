package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.text.Font;
	
	import mx.core.Application;
	import mx.styles.StyleManager;
	
	public class FontLoader extends EventDispatcher
	{		
		private static var loaded:Boolean = loadEmbedFonts();
		
		private static function loadEmbedFonts():Boolean
		{
			var deviceFonts:Array = Font.enumerateFonts(true);
			Application.application.fonts = deviceFonts;
			return true;
		}
	}
}