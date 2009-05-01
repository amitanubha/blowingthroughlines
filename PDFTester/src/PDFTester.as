package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class PDFTester extends Sprite
	{
		private var _pdfToLoad:URLRequest;
		private var _loader:URLStream;
		
		private var _output:ByteArray;
		
		public function PDFTester()
		{
			_pdfToLoad 	= new URLRequest("pdf/tester.pdf");
			_loader 	= new URLStream();
			_output		= new ByteArray();
			init();
		}
		
		private function init():void
		{
			_loader.addEventListener(Event.COMPLETE, 			handleComplete);
			_loader.addEventListener(ProgressEvent.PROGRESS, 	handleProgress);
			_loader.endian = Endian.LITTLE_ENDIAN;
//			_loader.objectEncoding = 0;//bjectEncoding.
//			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.load(_pdfToLoad);
		}
		
		private function handleProgress(evt:ProgressEvent):void
		{
			trace("loading:", evt.bytesTotal/1000);
		}
		
		private function handleComplete(evt:Event):void
		{
			var loader:URLStream = evt.target as URLStream;
			trace(loader.bytesAvailable/1000);
//			_output.writeObject(loader.readObject());
			loader.readBytes(_output, _output.bytesAvailable, loader.bytesAvailable);
//			_output.writeBytes(loader.readUTFBytes(loader.bytesAvailable), _output.length, loader.bytesAvailable);

			
			showBtn();
		}
		
		private function showBtn():void
		{
			var sprite:Sprite = new Sprite();
				sprite.graphics.beginFill(0xbada55);
				sprite.graphics.drawRect(0,0,100, 30);
				sprite.x = 100;
				sprite.y = 100;
				sprite.addEventListener(MouseEvent.CLICK, handleClick);
				
			this.addChild(sprite);
		}
		
		private function handleClick(evt:MouseEvent):void
		{
			var fr:FileReference = new FileReference();
			fr.save(_output, "myPDF.pdf");
		}
	}
}
