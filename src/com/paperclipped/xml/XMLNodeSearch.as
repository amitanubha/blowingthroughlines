/**
 * This class searches for node values in 2 (sofar) different ways
 * 
 * USAGE:
 * 	XMLNodeSearch.find(xml_to_search, "node_level_to_search", "node_to_search", "value_to_find");
 * RESULTS:
 * 	Returns and XML with only the node containing the node to search that matches
 * NOTE: second and third params can be the same
 * 
 * USAGE:
 * 	XMLNodeSearch.findIndex( same params as above );
 * RESULTS:
 * 	Returns the index of the node that was found (based on the node_level_to_search param).
 * 
 */

package com.paperclipped.xml
{
	import flash.xml.*;
	
	import nochump.util.zip.Inflater;
	
	public class XMLNodeSearch
	{	
		public function XMLNodeSearch()
		{
			trace('this is a static class\n\t', 'usage: XMLNodeSearch.find(sourceXML,resultNode:String,searchNode:String,value:String)');
		}
		public static function find(xml:XML, resultNode:String, searchNode:String, val:String):XML
		{
			if(!xml) return null;
			
			var results:XML = <response></response>;
			//trace(xml.descendants(resultNode).length());
			for(var i:uint=0; i<xml.descendants(resultNode).length(); i++)
			{
				var resultNodeCont:XML = xml.descendants(resultNode)[i];
				var searchNodeCont:XMLList = resultNodeCont.descendants(searchNode);
				//trace(searchNodeCont.length());
				for(var k:uint=0; k < searchNodeCont.length(); k++)
				{
					if(searchNodeCont[k] == val){
						//trace(returnNodeCont.@id, "searchNode value: "+searchNodeCont[k]);
						results.appendChild(resultNodeCont);
					}
				}
			}
			//if(array
			return results;
		}
		
		public static function findIndex(xml:XML, resultNode:String, searchNode:String, val:String):int
		{
			var index:int = -1;
			
			if(!xml) return index;
						
			for(var i:uint=0; i < xml.descendants(resultNode).length(); i++)
			{
				var resultNodeCont:XML = xml.descendants(resultNode)[i];
				var searchNodeCont:XMLList = resultNodeCont.descendants(searchNode);
				for(var k:uint=0; k < searchNodeCont.length(); k++)
				{
					if(searchNodeCont[k] == val){
						index = i;
						return index;
					}
				}
			}
			return index;
		}
		
		public static function removeNode(xml:XML, resultNode:String, searchNode:String, val:String):Boolean
		{
			var removalID:int 	= XMLNodeSearch.findIndex(xml, resultNode, searchNode, val);
			removalID 			= xml.descendants(resultNode)[removalID].childIndex();
			xml.replace(removalID, <nodeRemoved/>);
			
			return (removalID >= 0)?true:false;
		}
		
		/*public static function findAsArray(xml:XML, returnNode:String, searchNode:String, val:String):Array // may be needed later for sorting...
		{
			var results:Array = new Array();
			//trace(xml.descendants(returnNode).length());
			for(var i=0; i<xml.descendants(returnNode).length(); i++)
			{
				var returnNodeCont:XML = xml.descendants(returnNode)[i];
				var searchNodeCont:XMLList = returnNodeCont.descendants(searchNode);
				//trace(searchNodeCont.length());
				for(var k=0; k < searchNodeCont.length(); k++)
				{
					if(searchNodeCont[k] == val){
						//trace(returnNodeCont.@id, "searchNode value: "+searchNodeCont[k]);
						results.push(returnNodeCont);
					}
				}
			}
			//if(array
			return results;
		}*/
		// could (prolly should) do the array first, then sort it, then turn it back into an XML...
	}// end of class
}