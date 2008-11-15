package {
	import org.cove.ape.*;
	
	public class Box extends Group
	{
		private var _friction:Number = 0.01;
		
		
		private var _capsuleP1:CircleParticle;
		private var _capsuleP2:CircleParticle;
		private var _capsule:SpringConstraint;
		
		// getters & setters
		public function get x():Number	{	return Math.min(_capsuleP1.px, _capsuleP2.px);	}
		public function get y():Number	{	return Math.min(_capsuleP1.py, _capsuleP2.py);	}
		
		
		public function set x(val:Number):void
		{
			_capsuleP1.px = val;
			_capsuleP2.px = val+25; // should really get rotations first, too...lazy
		}
		public function set y(val:Number):void
		{
			_capsuleP1.py = val;
			_capsuleP2.py = val+25; // should really get rotations first, too...lazy
		}
		
		public function set friction(val:Number):void
		{
			_friction = val;
			_capsuleP1.friction = val;
			_capsuleP2.friction = val;
		}
		
		
		public function Box(colC:uint)
		{
	
			_capsuleP1 = new CircleParticle(300,10,14,false,1.3,0.4);
			_capsuleP1.setStyle(0, colC, 1, colC);
			addParticle(_capsuleP1);
			
			_capsuleP2 = new CircleParticle(325,35,14,false,1.3,0.4);
			_capsuleP2.setStyle(0, colC, 1, colC);
			addParticle(_capsuleP2);
			
			_capsule = new SpringConstraint(_capsuleP1, _capsuleP2, 1, true, 24);
			_capsule.setStyle(5, colC, 1, colC, 1);
			addConstraint(_capsule);
			
			this.friction = _friction;
		}
	}
}