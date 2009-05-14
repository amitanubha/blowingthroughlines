package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	[SWF(width="800", height="600")]
	public class IETester extends Sprite
	{
		public function IETester()
		{
			if(stage.stageWidth == 0)
				stage.addEventListener(Event.RESIZE, init);
			else
				init();
		}
		
		private function init(evt:Event=null):void
		{
			var testText:String = "There are "+ this.numChildren + " already on the stage.";
			
			var format:TextFormat = new TextFormat("_sans", 12);
			var tf:TextField = new TextField();
			tf.defaultTextFormat = format;
			tf.multiline	= true;
			tf.width		= 100;
			tf.autoSize 	= TextFieldAutoSize.LEFT;
			tf.background 	= true;
			
			for(var i:int; i < 20; i++)
			{
				var ner:Sprite = new Sprite();
				ner.graphics.beginFill(0, 0.2);
				ner.graphics.drawCircle(0,0, 20);
				ner.x = Math.random()*800;
				ner.y = Math.random()*600;
				
				this.addChild(ner);
			}
			
			testText += "\nNow there are "+this.numChildren+" there.";
			tf.text			= testText;
			
			this.addChild(tf);
		}
	}
}
