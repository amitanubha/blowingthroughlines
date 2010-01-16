package com.paperclipped.utils
{
	import flash.system.Capabilities;
	
	/**
	 * A set of utilities that to neat things to URLs and URIs.
	 * @author Collin Reisodrf
	 */	
	public class URIUtils
	{
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