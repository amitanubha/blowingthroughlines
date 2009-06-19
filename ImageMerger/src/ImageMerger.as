package {
	import com.adobe.images.PNGEncoder;
	import com.huntandgather.utils.Aligner;
	import com.huntandgather.utils.ColorUtils;
	import com.huntandgather.utils.Debugging;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
//	[SWF(width="200", height="40", backgroundColor="#FFFFFF")]
	
	/**
	 * This thing is gonna be rad.
	 * @author Collin Reisdorf
	 * @copyright c 2009 Collin Reidorf
	 *
	*/
	public class ImageMerger extends Sprite
	{
//-------------------------------------- Private Vars --------------------------------------
		private var _align			:String;
		private var _color			:Number;
		private var _input			:Loader;
		private var _inputType		:String;
		private var _output			:String;
		private var _outputBmp		:Bitmap;
		private var _outputSprite	:Sprite;
		private var _params			:Object;
		private var _type			:String;
		private var _watermark		:Loader;
		private var _watermarkBmp	:Bitmap;
		
//------------------------------------ Constructor/init ------------------------------------		
		public function ImageMerger()
		{
			trace(Debugging.printObjectArray(this.loaderInfo.parameters));
			init();
		}
		
		private function init():void
		{
			_params 	= this.loaderInfo.parameters;
			_input 		= (_params.hasOwnProperty("input"))? 		loadImage(_params['input'])				:null;
			_watermark	= (_params.hasOwnProperty("watermark"))?	loadImage(_params['watermark'])			:null;
			_type 		= (_params.hasOwnProperty("type"))? 		String(_params['type']).toLowerCase()	:null;
			_output 	= (_params.hasOwnProperty("output"))?		_params['output'] + "/"					:"";
			_color  	= (_params.hasOwnProperty("progressColor"))?ColorUtils.colorFromHexString(_params['progressColor'])	:0x0;
			_align		= (_params.hasOwnProperty("align"))?		String(_params['align']).toUpperCase()	:"MC";
			trace(_color, _align);
			
			if(_input && _watermark)
			{
				addLoadListeners(_input.contentLoaderInfo, 		handleInputComplete);
				addLoadListeners(_watermark.contentLoaderInfo, 	handleWatermarkComplete);
			}
			else
				handleError(new ErrorEvent("customError", false, false, "One of the required parameters is not defined!"));
		}
		
//------------------------------------- Private Methods -------------------------------------		
		private function addLoadListeners(target:LoaderInfo, completeClosure:Function):void
		{
			target.addEventListener(Event.COMPLETE, 		completeClosure);
			target.addEventListener(IOErrorEvent.IO_ERROR, 	handleError);
			target.addEventListener(ProgressEvent.PROGRESS, handleProgress);
		}
		
		private function drawOutput():void
		{
			if(_outputBmp && _watermarkBmp)
			{
				var watermarkLoc:Point = Aligner.getPosition((_outputBmp.width - _watermarkBmp.width), (_outputBmp.height - _watermarkBmp.height), _align);
				_watermarkBmp.x = watermarkLoc.x;
				_watermarkBmp.y = watermarkLoc.y;
				
				_outputSprite = new Sprite();
				_outputSprite.addChild(_outputBmp);
				_watermarkBmp.blendMode = BlendMode.OVERLAY;
				_outputSprite.addChild(_watermarkBmp);
				_outputBmp.bitmapData.draw(_outputSprite);
				
				this.addChild(_outputBmp);
				trace("running draw method");
//				_outputBmp.bitmapDat
			}else
				return;
		}
		
		private function loadImage(input:String):Loader
		{
			var request:URLRequest = new URLRequest(input);
			var loader:Loader = new Loader();
			loader.load(request);
			return loader;
		}
		
		//TODO: Export JPG, or PNG from flash (depending on params)
		private function saveImg(outputBmpData:BitmapData):void 
		{
			// create the encoder with the appropriate quality
//			var myEncoder:JPEGEncoder = new JPEGEncoder( qualityValue );
			
			// generate a JPG binary stream to have a preview
			var myCapStream:ByteArray = PNGEncoder.encode ( outputBmpData );
			
//			size_txt.text = Math.round ( myCapStream.length / 1024 ) + " kb";
			
			// show a preview of the stream with loadBytes
//			myPreviewLoader.loadBytes ( myCapStream );
			
		 	var header:URLRequestHeader = new URLRequestHeader ("Content-type", "application/octet-stream");
		 			
		 	var myRequest:URLRequest = new URLRequest ( "create2.php?name=snapshot.jpg" );
			
		 	myRequest.requestHeaders.push (header);
		 			
		 	myRequest.method = URLRequestMethod.POST;
		 			
//		 	myRequest.data = myCapStream; // the bitmap stream
			
			var loader:URLLoader = new URLLoader();
			loader.load ( myRequest );
			
		}
		
		//TODO: Return path to the newly created image with javascript external interface call.

//-------------------------------------- Event Handlers --------------------------------------		
		/**
		 * This checks to see that you're using an image with proper mimetype, then if no 
		 * output type is specified, it uses the input filetype.
		 * @param evt
		 */
		private function handleInputComplete(evt:Event):void
		{
			var type:Array = LoaderInfo(evt.currentTarget).contentType.split("/");
			if(type[0] != 'image')
				handleError(new ErrorEvent("customError", false, false, "'input' is not an image!"));
			
			_type = (_type)? _type:type[1];
			_outputBmp = evt.target.content as Bitmap;
			drawOutput();
		}
		
		private function handleWatermarkComplete(evt:Event):void
		{
			var type:Array = LoaderInfo(evt.currentTarget).contentType.split("/");
			if(type[0] != 'image')
				handleError(new ErrorEvent("customError", false, false, "'watermark' is not an image!"));
			
			_watermarkBmp = evt.target.content as Bitmap;
			drawOutput();
		}
		
		private function handleError(evt:ErrorEvent):void
		{
			if(ExternalInterface.available) ExternalInterface.call("alert", evt.text);
		}
		
		private function handleProgress(evt:ProgressEvent):void
		{
			//TODO: Make a seperate loader bar for each 
			trace(evt.target == _input.contentLoaderInfo);
			var prog:Number = evt.bytesLoaded/evt.bytesTotal;
			if(stage.stageWidth > 0)
			{
				this.graphics.clear();
				this.graphics.beginFill(_color);
				this.graphics.drawRect(0,0,stage.stageWidth * prog, stage.stageHeight);
				this.graphics.endFill();
			}
		}
	}
}
