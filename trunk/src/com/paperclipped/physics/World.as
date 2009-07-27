package com.paperclipped.physics
{
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;

	/**
	 * This is a container class to make the creation of Box2D World simpler.
	 * Box2D r47 or greater required.
	 * (c) 2009 Collin Reisdorf MIT License
	 * 
	 * @author Collin Reisodrf
	 */	
	public class World
	{
//-----------------------------------------Variables-----------------------------------------//
		private var _height:Number;
		private var _width:Number;
		private var _scale:Number;
		private var _world:b2World;
//-------------------------------------------------------------------------------------------//
		
//------------------------------------------Getters------------------------------------------//
		public function get height():Number		{ return _height;	}
		public function get width():Number		{ return _width;	}
		/**
		 * @return Scale set by the user when the world is constructed.
		 */				
		public function get scale():Number		{ return _scale;	}
		/**
		 * @return The world object made by the constructor.
		 */		
		public function get world():b2World		{ return _world;	}
//-------------------------------------------------------------------------------------------//

//----------------------------------------Constructor----------------------------------------//		
		public function World(width:uint, height:uint, debugSprite:Sprite=null, debugFlags:uint=0, gravity:b2Vec2=null, scale:Number=30, padding:uint=1000, doSleep:Boolean=true, continuous:Boolean=false)
		{
			_width = width;
			_height = height;
			_scale = scale;
			
			var worldAABB:b2AABB = new b2AABB();
				worldAABB.lowerBound.Set(-padding, -padding);
				worldAABB.upperBound.Set(width+padding, height+padding);
			
			gravity = (gravity)? gravity:new b2Vec2(0, 10.0);
			_world = new b2World(worldAABB, gravity, doSleep);
			_world.SetContinuousPhysics(continuous);
			
			if(debugSprite)
			{
				
				var	debugDraw:b2DebugDraw = new b2DebugDraw();
					debugDraw.SetSprite(debugSprite);
					debugDraw.SetDrawScale(scale);
					debugDraw.SetFillAlpha(0.3);
					debugDraw.SetLineThickness(1.0);
					debugDraw.SetFlags(uint((debugFlags==0)? b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit : debugFlags));
				_world.SetDebugDraw(debugDraw);
			}
		}
//-------------------------------------------------------------------------------------------//

//--------------------------------------Private Methods--------------------------------------//
//-------------------------------------------------------------------------------------------//

//--------------------------------------Public  Methods--------------------------------------//
//-------------------------------------------------------------------------------------------//
	}
}