package com.paperclipped.physics
{
	/**
	 * 
	 * @author collin
	 * 
	 */	
	public class Joint
	{
		public static const GEAR:String = "gear";		// GearJoint (not really any docs on this one yet...
		public static const HINGE:String = "hinge";		// RevoluteJoint
		public static const FIXED:String = "fixed";		// RevoluteJoint with 0 degrees of rotation applied
		public static const ROD:String = "rod";			// DistanceJoint
		public static const PULLY:String = "pully";		// PullyJoint
		public static const SLIDE:String = "slide";		// PrismaticJoint
		
		
		public function Joint()
		{
		}
	}
}