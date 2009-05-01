package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.DataEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.XMLSocket;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class WiiPS extends Sprite
	{
		private var _socket:XMLSocket;
		private var _host:String;
		private var _port:int;
		
		private var _tf:TextField;
		
		public function WiiPS()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align		= StageAlign.TOP_LEFT;
			_host 			= "127.0.0.1";
			_port 			= 45054;
			init();
		}
		
		private function init():void
		{	
			_socket = new XMLSocket(_host, _port);
			_socket.addEventListener(Event.CONNECT, handleConnect);
			_socket.addEventListener(DataEvent.DATA, handleData);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, handleError);
			
			var format:TextFormat = new TextFormat("_sans");
			_tf = new TextField();
			_tf.defaultTextFormat = format;
			_tf.text = "asdf";
			_tf.width = 500;
			_tf.height = 600;
			_tf.multiline = true;
			_tf.wordWrap = true;
//			_tf.autoSize = TextFieldAutoSize.LEFT;
			this.addChild(_tf);
		}
		
		private function handleConnect(evt:Event):void
		{
			trace(evt);
		}
		
		private function handleData(evt:DataEvent):void
		{
			var data:XML = XML(evt.data);
			
			trace("data:", data.elements());
			if(data.axisValue.length() > 0)
			{
				_tf.replaceText(0, _tf.text.length, "values:");
				for(var i:int = 0; i < data.axisValue.length(); i++)
				{
					//_tf.text += "ner";
					//_tf.appendText("ner");
					_tf.appendText(data.axisValue[i].@axis+": "+data.axisValue[i].@value+"\n");
				}
			}
//			var wx:String = data.axiValue.(@['axis'] == 'wx').@value;
//			var wy:String = 
//			
//			trace("hell:", ner);
//			if(ner.length > 0)
//				_tf.text = ner+"\n";
		}
		
		private function handleError(evt:ErrorEvent):void
		{
			_tf.text = evt.text;
		}
	}
}
