package {
	import flash.display.Sprite;
	import flash.events.Event;

	public class TesterTextLayoutFramwork extends Sprite
	{	
		public function TesterTextLayoutFramwork()
		{
			stage.scaleMode = "noScale";
			
			trace("loaded");
			var ner:Sprite = new Sprite();
			ner.graphics.beginFill(0x123456, 0.7);
			ner.graphics.drawRoundRect(0,0,300,300,50);
			ner.graphics.endFill();
			
			ner.x = 100	;
			ner.y = 100;
			ner.rotationX = 20;
			ner.rotationY = 20;
			ner.rotationZ = 20;
			ner.addEventListener(Event.ENTER_FRAME, handleFrame);
			this.addChild(ner);
		}
		
		private function handleFrame(evt:Event):void
		{
			
		}
	}
}
	