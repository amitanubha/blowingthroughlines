package com.paperclipped.utils
{
	import flash.system.Capabilities;
	
	public class URIUtils
	{
		public function URIUtils()
		{
			trace("WARNING: URIUtils is a static class, there is no point instanciating it.");
		}
		
		/**
		 * Allows automagic correction of paths, if the SWF is in a weird folder, or if
		 * you want to play the swf outside of an hmtl container. It makes the assumtion
		 * that your flash file is normally kept in a sub folder below the container html. 
		 * 
		 * @param 	serverPath	The path to the current location of the swf
		 * @return 				New URI prefix.
		 */		
		public static function prefix(serverPath:String = ""):String
		{
			var playerType:String = Capabilities.playerType;
			if (playerType == "External" || playerType == "StandAlone")
				return "../";
			else
				return serverPath;
		}
	}
}