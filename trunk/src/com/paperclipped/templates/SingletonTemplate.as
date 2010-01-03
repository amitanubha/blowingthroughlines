package com.paperclipped.templates
{
	public class SingletonTemplate
	{
//-------------------------------------- VARIABLES ------------------------------------------
		static private  var _instance:SingletonTemplate;
//-------------------------------------------------------------------------------------------


//--------------------------------------- GETTERS -------------------------------------------
//-------------------------------------------------------------------------------------------


//--------------------------------------- SETTERS -------------------------------------------
//-------------------------------------------------------------------------------------------


//------------------------------------- PUBLIC FUNCTIONS ------------------------------------
		// Constructor
		public function SingletonTemplate(singletonEnforcer:SingletonEnforcer)
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
		public static function getInstance():SingletonTemplate
		{
			if (SingletonTemplate._instance == null)
			{
				SingletonTemplate._instance = new SingletonTemplate( new SingletonEnforcer());
				_data = new Object();
			}
			return SingletonTemplate._instance;
		}
//-------------------------------------------------------------------------------------------
	}
}

class SingletonEnforcer
{}