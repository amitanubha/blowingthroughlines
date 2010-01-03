package com.paperclipped.ui
{
	import flash.display.Stage;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class PaperclippedContextMenu
	{
		private var _mainStage		:Stage;
		private var _contextMenu	:ContextMenu;
		
		public function get menu():ContextMenu	{ return _contextMenu;	}
		
		public function PaperclippedContextMenu()
		{
			init();
		}
		
		public function addItem(title:String, listener:Function):ContextMenu
		{
			var newItem:ContextMenuItem = new ContextMenuItem(title);
				newItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, listener);
			_contextMenu.customItems.push();
			return _contextMenu;
		}
		
		private function init():void
		{
			buildContextMenu();
		}
		
		
		private function buildContextMenu():ContextMenu
		{
			_contextMenu	= new ContextMenu();
			_contextMenu.hideBuiltInItems();
			
			var fsItem:ContextMenuItem = new ContextMenuItem("Toggle fullscreen mode");
  				fsItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleContextFS);
    		_contextMenu.customItems.push(fsItem);
			
			var hgItem:ContextMenuItem = new ContextMenuItem("Site by Paperclipped.com");
  				hgItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleContextSite);
    		_contextMenu.customItems.push(hgItem);
			
			return _contextMenu;
		}
		
		private function handleContextFS(e:ContextMenuEvent):void
		{
			switch(_mainStage.displayState) {
				case "normal":
					_mainStage.displayState = "fullScreen";    
					break;
				case "fullScreen":
				default:
					_mainStage.displayState = "normal";    
					break;
			}
		}
		
		private function handleContextSite(e:ContextMenuEvent):void
		{
			_siteController.goToURL("http://paperclipped.com/", _blank);
		}
	}
}