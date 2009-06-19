package com.paperclipped.utils
{
	import flash.utils.ByteArray;

	public class BigByteArray extends ByteArray
	{
//		override public function get bytesAvailable():uint
//		public function set bytesAvailable():uint
		
		public function BigByteArray()
		{
			super();
//			super.bytesAvailable
//			super.readObject()
		}
		
		override public function readByte():int
		{
			trace("readByte called");
			return super.readByte();
		}
		override public function readBytes(bytes:ByteArray, offset:uint=0, length:uint=0):void
		{
			trace("readBytes called", bytes, offset, length);
			super.readBytes(bytes, offset, length);
		}
		override public function readObject() // Adobe left off the return type!!!
		{
			trace("readObject called");
			return super.readObject();
		}
		override public function readMultiByte(length:uint, charSet:String):String
		{
			trace("readMultiByte called", length, charSet);
			return super.readMultiByte(length, charSet);
		}
	}
}