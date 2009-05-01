package
{
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import com.senocular.images.BMPEncoder;
	
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.net.FileReference;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import mx.containers.Canvas;
	import mx.controls.CheckBox;
	import mx.controls.TextArea;
	import mx.core.Application;
	import mx.events.ColorPickerEvent;
	import mx.events.ListEvent;
	import mx.graphics.codec.JPEGEncoder;

	public class ImageEncoderDemo extends Application
	{
		public function ImageEncoderDemo()
		{
			super();
		}
		
		public var text:TextArea;
		public var canvas:Canvas;
		public var isCorelib:CheckBox;
		
		[Bindable]
		public var fonts:Array;
		
		[Bindable]
		protected var costTime:Number = 0;
		
		protected function fontsChangeHandler(event:ListEvent):void
		{
			text.setStyle("fontFamily",event.currentTarget.selectedItem.fontName);
		}
		
		protected function textColorChangeHandler(event:ColorPickerEvent):void
		{
			text.setStyle("color",event.color);
		}
		
		protected function canvasColorChangeHandler(event:ColorPickerEvent):void
		{
			canvas.setStyle("backgroundColor",event.color);
		}
		
		protected function application_KeyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ESCAPE)
			{
				application.setFocus();
			}
		}
		
		protected function save(type:String):void
		{
			var bitmapData:BitmapData = new BitmapData(canvas.width,canvas.height);
			bitmapData.draw(canvas);
			
			var encoder:Object = new Object();
			var defaultName:String;
			
			switch(type)
			{
				case "JPG":
				{
					var je:*;
					if(!isCorelib.selected)
					{
						je = new JPGEncoder(100);							
					}
					else
					{
						je = new JPEGEncoder(100);
					}
					
					encoder.encode = je.encode;
					defaultName = "myImage.jpg";
					break;
				}
				case "PNG":
				{
					if(!isCorelib.selected)
					{
						encoder.encode = PNGEncoder.encode;
					}
					else
					{
						var pe:mx.graphics.codec.PNGEncoder = new mx.graphics.codec.PNGEncoder();
						encoder.encode = pe.encode;
					}
					defaultName = "myImage.png";
					break;
				}
				
				case "BMP":
				{
					encoder.encode = BMPEncoder.encode;
					defaultName = "myImage.bmp";
					break;
				}
			}
			
			var time:Date = new Date();			
			costTime = time.getTime();
			
			var imageBytes:ByteArray = encoder.encode(bitmapData);
						
			time = new Date();
			costTime = time.getTime() - costTime;
			
			var fr:FileReference = new FileReference();
			fr.save(imageBytes,defaultName);
		}
	}
		
}