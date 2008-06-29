package {
	import flash.display.Sprite;
	import com.pixelwelders.textcloud.MotifCollection3D;
	
	import five3D.display.DynamicText3D;
	import five3D.display.Scene3D;
	import five3D.display.Sprite3D;
	import five3D.typography.HelveticaBold;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	//import mx.core.Singleton;
	//import mx.resources.IResourceManager;
	//import mx.resources.ResourceManager;
	//import mx.rpc.events.FaultEvent;
	//import mx.rpc.events.ResultEvent;
	//import mx.rpc.http.HTTPService;
	
	[SWF(backgroundColor="#FFFFFF", width="750", height="400", frameRate="60")]
	public class PixelWeldersTextCloud extends Sprite
	{
		private var scene:Scene3D;
		private var container:Sprite3D;
		private var text:DynamicText3D;
		
		private var letters:Array;
		private var letters2:Array;
		private var letterSprites:Array;
		
		// mouse movement
		private var targetRotationX:Number;
		private var targetRotationY:Number;
		
		private var assembled:Boolean;
		
		private var cloud			: MotifCollection3D;
		private var cloud2			: MotifCollection3D;
		
		public function PixelWeldersTextCloud()
		{

			initStage();
			initFive3D();
			
			stage.addEventListener( MouseEvent.MOUSE_MOVE, handleMouseMove );
			stage.addEventListener( MouseEvent.CLICK, handleMouseClick);
			addEventListener( Event.ENTER_FRAME, handleEnterFrame );
			
			targetRotationX = 0;
			targetRotationY = 0;
			
			cloud = new MotifCollection3D( "PIXELWELDERS LLC", HelveticaBold, 30, 0xD34328 );
			cloud.x = -150;
			cloud.y = -14
			container.addChild( cloud );
			
			cloud2 = new MotifCollection3D( "We're kind of a big deal.", HelveticaBold, 20, 0x3964C3 );
			cloud2.x = -75;
			cloud2.y = 14;
			container.addChild( cloud2 );
			
			container.filters = [ new GlowFilter( 0x000000, 1, 2, 2, 1 ) ];
			container.z = -300;
		}
		
		private function initStage(): void
		{
			var frame:Sprite = new Sprite();
			frame.graphics.lineStyle( 1, 0x000000, 1 );
			frame.graphics.drawRect( 0, 0, 749, 399 );
			stage.addChild( frame );
		}
		
		private function initFive3D(): void
		{
			scene = new Scene3D();
			scene.x = 375;
			scene.y = 200;
			addChild( scene );
			
			container = new Sprite3D();
			scene.addChild( container );
		}
		
		// === E V E N T   H A N D L E R S ===
		private function handleMouseMove( event:MouseEvent ): void
		{ 
			if ( event.stageX > 0 && event.stageX < 750 && event.stageY > 0 && event.stageY < 400 )
			{
				targetRotationX = ( event.stageX - stage.width / 2 ) / 7;
				targetRotationY = -( event.stageY - stage.height / 2 ) / 7;
			}
		}
		
		private function handleMouseClick( event:MouseEvent ): void
		{
			if ( cloud.assembled )	// assume that if one is assembled, both are
			{
				cloud.explode( 4, null, 200 )
				cloud2.explode( 4, null, 300 );
			} else {
				cloud.assemble();
				cloud2.assemble();
			}
		}
		
		private function handleEnterFrame( event:Event ): void
		{
			var moveSpeed:Number = 8;
			container.rotationY -= ( container.rotationY - targetRotationX ) / moveSpeed;
			container.rotationX -= ( container.rotationX - targetRotationY ) / moveSpeed;
		} 
		
	}
}
