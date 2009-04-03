package {
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	[SWF(backgroundColor="#5ea2fc")]
	public class SWFAddress_test extends Sprite
	{
		private var _square:Shape;
		private var _tf:TextField;
		
		public function SWFAddress_test()
		{
			SWFAddress.addEventListener(SWFAddressEvent.INIT, init);
		}
		
		private function init(evt:SWFAddressEvent):void
		{
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, handleSWFAddressChange);
			stage.addEventListener(MouseEvent.CLICK, gotoAddress);
			
			addText("Click anywhere on the stage to move the box, use the back/forward buttons to undo/redo.");
			addSquare(0xbada55);			
		}
		
		private function handleSWFAddressChange(evt:SWFAddressEvent):void
		{
			trace(evt.path);
			var address:Array = evt.path.split("/", 3);
			var loc:Point = new Point(	(!isNaN(address[1]))? address[1]:0,
										(!isNaN(address[2]))? address[2]:0);
			moveSquare(loc);
			
		}
		
		private function gotoAddress(evt:MouseEvent):void
		{
			var boxLoc:String = (this.mouseX - _square.width/2).toString() + "/" + (this.mouseY - _square.height/2).toString();
			SWFAddress.setValue(boxLoc);
		}
		
		private function moveSquare(loc:Point):void
		{
			_square.x = loc.x;
			_square.y = loc.y;
		}
		
		private function addSquare(color:Number):void
		{
			_square = new Shape();
			_square.graphics.beginFill(0xc07712, 0.5);
			_square.graphics.drawRect(0,0,50,50);
			this.addChild(_square);
		}
		
		private function addText(val:String):void
		{
			var format:TextFormat = new TextFormat("Georgia, Times, serif", 48, 0xc07712, true, true);
			format.leading = -1;
			
			_tf = new TextField();
			_tf.defaultTextFormat = format;
			_tf.text = val;
			_tf.wordWrap = true;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.width = 650;
			_tf.x = 100;
			_tf.y = 300;
			this.addChild(_tf);
		}
	}
}