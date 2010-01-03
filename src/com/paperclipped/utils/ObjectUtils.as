package com.paperclipped.utils
{
	import com.adobe.serialization.json.JSON;
	import flash.utils.ByteArray;
	
	public class ObjectUtils
	{
		/**
		 * Makes a clone of an object or array at least, might do more...
		 * @param source	Object or Array sofar.
		 * @return 			A clone of whatever when in.
		 */		
		public static function clone(obj:Object):*
		{
		    var newObj:ByteArray = new ByteArray();
		    newObj.writeObject(obj);
		    newObj.position = 0;
		    return(newObj.readObject());
		}
		
		/**
		 * Overwrites or adds values in second param, with objects in first.
		 * @param obj1	Object to add.
		 * @param obj2	Object to return.
		 * @return 		Object consisting of existing object populated with 
		 * new object properties
		 */		
		public static function mergeObjects( newObject:Object, existingObject:Object ):Object
		{
			var returnObj:Object = clone(existingObject);
			for(var el:* in newObject)
				returnObj[el] = newObject[el];
			return returnObj;
		}
		
		/**
		 * Takes an object and turns it into a string, which happens to be a JSON string too.
		 * @param obj
		 * @return 
		 */		
		public static function print(obj:Object):String
		{
			return JSON.encode(obj);
		}
		
		/**
		 * Takes an old object and adds or rewrites the new one's properties to it. It's kinda
		 * inefficient, because it uses a for...in loop.
		 * 
		 * @param oldObj	The object that you'd like to update.
		 * @param newObj	An object with the new properties to add.
		 * @return 			The old object that you wanted to update.
		 */		
		public static function updateObject(oldObj:Object, newObj:Object):Object
		{
			for(var el:Object in newObj)
			{
				oldObj[el] = newObj[el];
			}
			return oldObj;
		}
	}
}