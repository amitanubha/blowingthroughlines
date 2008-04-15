package
{
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	
	public class Tester extends Sprite
	{
		private var linkTest:TestButton;
		
		public function Tester()
		{
			linkTest = new TestButton();
			linkTest.x = 20;
			linkTest.y = 20;
			linkTest.name_txt.text = "Awesome!!!";
			linkTest.name_txt.autoSize = TextFieldAutoSize.LEFT;
			linkTest.name_txt.antiAliasType = AntiAliasType.ADVANCED;
			linkTest.name_txt.selectable = false;
			linkTest.buttonMode = true;
			linkTest.mouseChildren = false;
			this.addChild(linkTest);
		}

	}
}