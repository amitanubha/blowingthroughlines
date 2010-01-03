package com.paperclipped.events
{
	import flash.events.Event;

	public class HGSliderEvent extends Event
	{
		public static const SNAP:String = "snap";
		
		private var _location:int;
		
		public function get location():uint {	return _location;	}
		
		public function HGSliderEvent(type:String, location:int)
		{
			_location = location;
			super(type, false, false);
		}
		
	}
}