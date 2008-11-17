package {
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class Box2DTester extends Sprite
	{
		private var _holder:Sprite;
		
		public function Box2DTester()
		{
			_holder = new Sprite();
			
			init();
			
			this.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		}
		
		private function init():void
		{
//			var aabb:b2AABB = new b2AABB();
//			aabb.lowerBound = new b2Vec2();
//			
//			
//			
//			var world:b2World = new b2World(new b2AABB(), new b2Vec2(), true);
//			this.addChild(world);
		}
		
		private function update(evt:Event):void
		{
			trace("updating");
			// clear for rendering
			_holder.graphics.clear()
		}
	}
}
