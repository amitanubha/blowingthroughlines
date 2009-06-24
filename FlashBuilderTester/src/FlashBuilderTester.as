package
{
	import flash.display.Sprite;
	import flash.text.engine.FontPosture;
	import flash.text.engine.Kerning;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.TextFilter;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.Configuration;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;

	public class FlashBuilderTester extends Sprite
	{
		public function FlashBuilderTester()
		{
			var config:Configuration = new Configuration();
			var textLayoutFormat:TextLayoutFormat = new TextLayoutFormat();
			textLayoutFormat.color = 0xFF0000;
			textLayoutFormat.fontFamily = "Arial, Helvetica, _sans";
			textLayoutFormat.fontSize = 20;
			textLayoutFormat.kerning = Kerning.ON;
			textLayoutFormat.fontStyle = FontPosture.ITALIC;
			textLayoutFormat.textAlign = TextAlign.LEFT;
			textLayoutFormat.firstBaselineOffset = 20; // AWESOME! Offsets the first line of the textfield. BUMMER! it scrolls funny when selected...
			textLayoutFormat.columnCount = 2;
			config.textFlowInitialFormat = textLayoutFormat;
			
			var textFlow:TextFlow = TextFilter.importToFlow("<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p> <p>Another paragraph!</p>", TextFilter.HTML_FORMAT); //new TextFlow(config);
			var selectionManager:SelectionManager = new SelectionManager();
			textFlow.format = textLayoutFormat;
			textFlow.interactionManager = selectionManager;
//			var p:ParagraphElement = new ParagraphElement();
//			var p2:ParagraphElement = new ParagraphElement();
//			var span:SpanElement = new SpanElement();
//			var span2:SpanElement = new SpanElement();
//			span.text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. <p>Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p> Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
//			span2.text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
//			
//			p.addChild(span);
//			p2.addChild(span2);
//					
//			textFlow.addChild(p);
//			textFlow.addChild(p2);
			
			textFlow.flowComposer.addController(new ContainerController(this,500,300));
			textFlow.flowComposer.updateAllControllers();


			
			trace(textFlow);
			for(var el:String in textFlow.configuration)
			{
				trace("\t-", el+":", textFlow.configuration[el]);
			}
		}
	}
}