package com.paperclipped.portfolio.controller
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.paperclipped.portfolio.model.SiteData;
	
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class SiteController extends EventDispatcher
	{
		public static const ITEM_CHANGE	:String = "itemChange";
		public static const STAGE_RESIZE:String = "stageResize";
		
		static private var _instance	:SiteController;
				
		private var _data				:SiteData;
		private var _itemGroup			:String;
		
		public function SiteController(singletonEnforcer:SingletonEnforcer)
		{
			if (singletonEnforcer == null)
			{
				throw new Error("Incorrect instantiation of singleton");
			}
			
			_itemGroup = "home";
			SWFAddress.addEventListener(SWFAddressEvent.INIT, initSiteCtrl);
		}
		
		public static function getInstance():SiteController
		{
			if (SiteController._instance == null)
			{
				SiteController._instance = new SiteController(new SingletonEnforcer());
			}
			return SiteController._instance;
		}
		
		public function initSiteCtrl(e:Event):void
		{
			if(!_data)_data					= SiteData.getInstance();

			var str:String					= readAddress();
			var address:Array				= str.split("/");
			var xml_path:String 			= SiteData.BASE_ADDRESS+"/pages/"+_itemGroup+".xml";		// load said itemGroup's URL
//			var xml_path:String 			= SiteData.BASE_ADDRESS+"/pages/"+"projects"+".xml";
			var request:URLRequest 			= new URLRequest(xml_path);
			var loader:URLLoader 			= new URLLoader();
				loader.addEventListener(Event.COMPLETE, onLoadComplete);
//				loader.load(request);
			
			
		}
		
		private function onLoadComplete(e:Event):void
		{
			var loader:URLLoader 			= URLLoader(e.currentTarget);
			var xml:XML						= XML(loader.data);
			_data.parseItemXML(xml);
			
			constructSiteCtrl();
		}
		
		private function newLoadComplete(e:Event):void
		{
			var loader:URLLoader 			= URLLoader(e.currentTarget);
			var xml:XML						= XML(loader.data);
			
			//_data.hideAll()
			
			_data.parseItemXML(xml);
		}
		
		public function constructSiteCtrl():void // nice to know what this is?
		{				
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, addressChange);
		}
		
		// Singleton Instantiation
		
		public function readAddress():String
		{
			var str:String					= SWFAddress.getPath();
			return str;
		}
		
		public function addToURL(type:String, id:String=null, itmObj:Object=null, addSet:String=""):void
		{			
			SWFAddress.setValue("");		
		}
				
		public function removeFromURL(removeStr:String):void
		{			
			var target:String;
			switch(removeStr)
			{
				case "section":
					target					= "section=";
					break;
				case "project":
					target 					= "project=";
					break;
				case "list":
					target 					= "list";
					break;
			}			
			
			var str:String					= _data.currentURL;
			var address:Array				= str.split("/");
			var thisStr:String;
			var sIndex:int;
			
			for(var i:int=0; i<address.length; i++)
			{
					
				if(target!="list")
				{
					thisStr					= address[i];
					if(thisStr.indexOf(target)!= -1){ sIndex=i};
				}
				if(target=="list" && target.length==4)
				{
					thisStr					= address[i];
					if(thisStr.indexOf(target)!= -1){ sIndex=i};
				}
			}
			
			var del:Array					= address.splice(sIndex,1);
			var url:String					= "";
			
			for(var j:int=1; j<address.length; j++){
				if(address[j]!=null){
					url	+= "/"+address[j];
				}
			}
			
			SWFAddress.setValue(url);
			
		}
		
		public function clearAddress():void
		{
			SWFAddress.setValue("");
		}
		
		public function goToURL(str:String):void
		{
			SWFAddress.href(str,'_blank')
		}
		
		private function addressChange(e:SWFAddressEvent=null):void
		{
			trace("======ADDRESS CHANGE======");
			// parse address
			
			// run changes
			
			SWFAddress.setTitle(SiteData.BASE_TITLE+"");
			
			dispatch();
		}
				 
 		private function loadSectionXML(path:String):void
		{
			var xml_path:String= path;
			var request:URLRequest = new URLRequest(xml_path);
			var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, handleLoadSectionXML);
				loader.load(request);
			
		}
 		
 		private function handleLoadSectionXML(e:Event=null):void
		{
			
		}

 
		public function dispatch():void
		{
//			trace("dispatch")

			this.dispatchEvent(new Event(SiteController.ITEM_CHANGE));
		}
		
		public function stageResize():void
		{
			this.dispatchEvent(new Event(SiteController.STAGE_RESIZE));
		}
		
	}
}

class SingletonEnforcer
{}