package com.huntandgather.factoryexample
{
	public class AbstactGame
	{

		// template method
		public final function initialize():void
		{
			var field:IField = createField();
			field.drawField();
			createTeam("red");
			createTeam("blue");
			startGame();
		}
		
		public function createField():IField
		{
			abstractEnforcer();
			return null;
		}
		
		public function createTeam(name:String):void
		{
			abstractEnforcer();
		}
		
		public function startGame():void
		{
			abstractEnforcer();
		}
		
		private function abstractEnforcer():void
		{
			throw new Error(this+" called an abstract method!");
		}
	}
}