package {
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class SWFAddress_test extends Sprite
	{
		private var _square:Shape;
		
		public function SWFAddress_test()
		{
			//stateManager = new SWFAddress();
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, printChange);
			//SWFAddress.addEventListener(SWFAddressEvent.INIT, printInit);
			stage.addEventListener(MouseEvent.CLICK, gotoAddress);
			
			_square = new Shape();
			_square.graphics.beginFill(0x0);
			_square.graphics.drawRect(0,0,50,50);
			this.addChild(_square);
		}
		
		/*private function printInit(evt:SWFAddressEvent):void
		{
			trace(SWFAddress.getBaseURL());
		}*/
		
		private function printChange(evt:SWFAddressEvent):void
		{
			trace(evt.path);
			var address:Array = evt.path.split("/", 3);
			var xLoc:Number = Number(address[1]);
			if(!isNaN(xLoc)) moveSquare(xLoc);
			
		}
		
		private function gotoAddress(evt:MouseEvent):void
		{
			trace(SWFAddress.getValue());
			SWFAddress.setValue(this.mouseX.toString());
		}
		
		private function moveSquare(loc:Number):void
		{
			_square.x = loc;
		}
		
	}
}
