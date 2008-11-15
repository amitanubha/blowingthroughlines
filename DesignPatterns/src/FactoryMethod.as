package {
	import com.huntandgather.factoryexample.FootballGame;
	
	import flash.display.Sprite;

	public class FactoryMethod extends Sprite
	{
		public function FactoryMethod()
		{
			var game:FootballGame = new FootballGame();
			game.initialize();
		}
	}
}
