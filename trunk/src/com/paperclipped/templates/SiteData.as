package com.paperclipped.keds
{
	import flash.events.Event;
	
	public dynamic class SiteData
	{
//-------------------------------------- VARIABLES ------------------------------------------
		static private  var _instance:SiteData;
//-------------------------------------------------------------------------------------------


//--------------------------------------- GETTERS -------------------------------------------
//-------------------------------------------------------------------------------------------


//--------------------------------------- SETTERS -------------------------------------------
//-------------------------------------------------------------------------------------------


//------------------------------------- PUBLIC FUNCTIONS ------------------------------------
		// Constructor
		public function SiteData(singletonEnforcer:SingletonEnforcer)
		{
			if (singletonEnforcer == null)
			{
				throw new Error("Incorrect instantiation of singleton");
			}else
			{
				init();
			}
		}
//-------------------------------------------------------------------------------------------


//------------------------------------ PRIVATE FUNCTIONS ------------------------------------
		private function init():void
		{
			//TODO init stuff
		}
//-------------------------------------------------------------------------------------------


//-------------------------------------- EVENT HANDLERS -------------------------------------
		private function handleSomeEvent(evt:Event):void
		{
			//TODO event handler stuff.
		}
//-------------------------------------------------------------------------------------------


//-------------------------------- SINGLETON INSTANTIATION ----------------------------------
		// Singleton Instantiation
		public static function getInstance():SiteData
		{
			if (SiteData._instance == null)
			{
				SiteData._instance = new SiteData( new SingletonEnforcer());
//				_data = new Object();
			}
			return SiteData._instance;
		}
//-------------------------------------------------------------------------------------------
	}
}

class SingletonEnforcer
{}