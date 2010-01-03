package com.paperclipped.utils
{

	/**
	 * Some useful methods for debugging and tracing stuffs happening in Flash / Flex durring runtime.
	 * This has only been lightly tested so please be mindful of Debugging-related errors.
	 * @author creisdorf
	 */	
	public class Debugging
	{
		/**
		 * Returns the class, method and line number of the call specefied by depth. It defaults to the last caller.
		 * @param depth		0 to Maximum depth from last caller down to first. Negative integers will return callers from the end of the stack in.
		 * @return 			The caller at a specified depth, or the max depth if the depth out of bounds.
		 * 
		 * @see Error#getStackTrace()
		 */		
		public static function getCaller(depth:int = 0):String
		{
			var e:Error = new Error;
			var callers:Array = getCallerArray(e);
			if(depth < 0) depth = callers.length + depth;

			return (depth < callers.length && depth >= 0) ? "Caller "+depth+": "+callers[depth] : "No caller at "+depth+", max depth was " + String(callers.length-1);
		}
		
		/**
		 * Returns the class, method and line number of all callers to the method. Similar to the StackTrace.
		 * @return 			An Array of all callers to the method it was called from.
		 * 
		 * @see Error#getStackTrace()
		 */		
		public static function getAllCallers():Array
		{
			var e:Error = new Error;
			return getCallerArray(e);
		}
		
		private static function getCallerArray(e:Error):Array
		{
			var stack:String = e.getStackTrace();
			stack = stack.substring(stack.indexOf("at ")+3);
			var callers:Array = stack.split("at ");
			callers.splice(0,3);

			return callers;
		}
	
//		public static function getAllCallers(method:String):String
//		{
//			var e:Error = new Error;
//			var stack:String = e.getStackTrace();
//			stack = stack.substring(stack.indexOf(method) + method.length); //,stack.indexOf("]", stack.l)+1)
//			stack = stack.substring(stack.indexOf(method));
//			return stack;
//		}

		/**
		 * This needs to be recursive at some point...
		 * 
		 * @param obj the object to print
		 * @param prop
		 * @return 
		 * 
		 */		
		public static function printObjectArray(obj:Object, prop:String=null):String
		{
			var str:String = "";
			
			for(var el:String in obj)
			{
				str += (prop)? prop:el;
				str += ": ";	
				str += (prop)? obj[el][prop]:obj[el];
				str += ", ";
			}
			
			str = str.substr(0, str.length-2); // removes the last comma
			
			return str;
		}
		
//		private static function parseObject(obj:Object, str:String):String
//		{
//			
//		}
	}
}