package
{
	import com.paperclipped.fx.DotMatrix;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width='960', height='600', backgroundColor='#000000', frameRate='30')]
	
	public class DotMatrixTester extends Sprite
	{
		public function DotMatrixTester()
		{
		
			var ner:Shape = new Shape();
			ner.addEventListener(Event.ENTER_FRAME, handleFrame);
			ner.dispatchEvent(new Event(Event.ENTER_FRAME));
			
			
			var dots:DotMatrix = new DotMatrix(ner, 2.5, true, true, 0x666666);
			
			this.addChild(dots);
		}
		
		public function handleFrame(evt:Event):void
		{
			var ner:Shape = Shape(evt.target);
				ner.graphics.clear();
				ner.graphics.beginFill(0x333333);
				ner.graphics.drawRect(0, 0, 200, 160); 
				ner.graphics.endFill();
				
				ner.graphics.lineStyle(10, 0xffffff, 1, true);
				ner.graphics.drawCircle((ner.mouseX < 200 - 60)? ner.mouseX : 140, (ner.mouseY < 160 - 60) ? ner.mouseY : 100, 50);
		}
	}
}