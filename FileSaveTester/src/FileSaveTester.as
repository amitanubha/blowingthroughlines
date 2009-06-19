package {
	import com.paperclipped.utils.BigByteArray;
	
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;

	public class FileSaveTester extends Sprite
	{
		private var _bba:BigByteArray = new BigByteArray();
		private var fr:FileReference = new FileReference();
		
		
		public function FileSaveTester()
		{
			init();
		}
		public function init():void
		{
			_bba.writeInt(1234);
			
			addButtons();
		}
		
		private function addButtons():void
		{
			var ner:Sprite = new Sprite();
			ner.graphics.beginFill(0xBADA55);
			ner.graphics.drawRoundRect(0,0,60,20,5);
			ner.addEventListener(MouseEvent.CLICK, handleClick);
			this.addChild(ner);
			
			var wer:Sprite = new Sprite();
			wer.y = 30;
			wer.graphics.beginFill(0xC07712);
			wer.graphics.drawRoundRect(0,0,60,20,5);
			wer.addEventListener(MouseEvent.CLICK, handleClick2);
			this.addChild(wer);
		}
		
		private function handleClick(evt:MouseEvent):void
		{
			fr.save(_bba, "NER");
		}
		
		private function handleClick2(evt:MouseEvent):void
		{
			fr.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, handleUpload);
			fr.addEventListener(Event.SELECT, handleSelect);
			fr.browse();
		}
		
		private function handleSelect(evt:Event):void
		{
			trace("selected:", fr.name);
			fr.upload(new URLRequest("http://localhost/work/blowingthroughlines/FileSaveTester/bin-debug/input/"));
		}
		
		private function handleUpload(evt:DataEvent):void
		{
			trace("upload complete", evt);
		}
	}
}
