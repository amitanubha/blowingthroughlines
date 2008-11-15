package com.huntandgather.factoryexample
{
	public class FootballGame extends AbstactGame
	{
		public override function createField():IField
		{
			return new FootballField();
		}
		public override function createTeam(name:String):void
		{
			trace("create football team named:", name);
		}
		public override function startGame():void
		{
			trace("start football game");
		}
	}
}