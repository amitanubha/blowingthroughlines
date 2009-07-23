package com.paperclipped.physics
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.Shapes.b2ShapeDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix;

	public class Body
	{
//-----------------------------------------Variables-----------------------------------------//
		public static const CIRCLE:String = "circle";
		public static const POLYGON:String = "polygon";
		public static const RECTANGLE:String = "square";
		public static const TRIANGLE:String = "triangle";
		
		private var _body:b2Body;
		private var _bodyDef:b2BodyDef;
		private var _scale:Number;
		private var _world:b2World;
		private var _graphic:DisplayObject;
//		private var _angle:Number; // haven't had a reason to store this stuff yet.
//		private var _friction:Number;
//		private var _restitution:Number;
//		private var _density:Number;
//-------------------------------------------------------------------------------------------//
		
//------------------------------------------Getters------------------------------------------//		
		/**
		 * The b2Body that is created by the Constructor.
		 */		
		public function get body():b2Body				{ return _body;		}
		/**
		 * A DisplayObject to represent the Body. Don't forget to add it to the stage! 
		 * It will automatically be positioned over the b2Body and rotated and scaled to 
		 * match the shape scale. It uses Matrix positioning to most accurately match the
		 * box2d locations.
		 * @see 	http://www.box2d.org/wiki/index.php?title=Linking_graphics_to_bodies_in_Box2D_AS3#A_different_approach
		 */		
		public function get graphic():DisplayObject 	{ return _graphic;	}
//		public function get radius()
//		public function get width()
//		public function get height()
//-------------------------------------------------------------------------------------------//

//------------------------------------------Setters------------------------------------------//
		public function set graphic(val:DisplayObject):void
		{
			if(val)
			{
				_graphic = val;
				_graphic.addEventListener(Event.ENTER_FRAME, updateGraphic);
			}else
			{
				if(_graphic)
				{
					_graphic.removeEventListener(Event.ENTER_FRAME, updateGraphic);
				}
				_graphic = null;
			}
		}
//-------------------------------------------------------------------------------------------//

//----------------------------------------Constructor----------------------------------------//
		/**
		 * Makes a shape and adds it to the world. Has lots of handy defaults to get moving quickly.
		 * 
		 * @param world			The World object to add the body to.
		 * @param x				X location of the body (in normal dimensions).
		 * @param y				Y location of the body (in normal dimensions).
		 * @param w				Width of rectangle or diameter of circle.
		 * @param h				Height of rectangle, ignored for all other shapes.
		 * @param shape			Type of shape Body.CIRCLE, Body.RECTANGLE, Body.Triangle or Body.POLYGON accepted.
		 * @param vertices		Array of b2Vec2 objects from 3 to 8 points.
		 * @param group			Collision group to add the body to.
		 * @param angle			Angle in degrees.
		 * @param isBullet		Is this a fast moving body that should be prevented from tunneling through other moving bodies? Note that all bodies are prevented from tunneling through static bodies.
		 * @param friction		The shape's friction coefficient, usually in the range [0,1].
		 * @param restitution	The shape's restitution (elasticity) usually in the range [0,1].
		 * @param density		The shape's density, usually in kg/m^2.
		 * @param categoryBits	!!! Still don't undestand this!!!
		 * @param maskBits		!!! Still don't undestand this!!!
		 * 
		 * @see #staticBody()
		 * @see #complexBody()
		 */		
		public function Body(world:World, x:int, y:int, w:Number=20, h:Number=20, shape:String="circle", vertices:Array=null, group:int=0, angle:Number=0, isBullet:Boolean=false, friction:Number=0.3, restitution:Number=0.1, density:Number=1.0, categoryBits:Number=0x0000, maskBits:Number=0x0000, displayGraphic:DisplayObject=null)
		{
			_bodyDef 	= new b2BodyDef();
			_scale 		= world.scale;
			_world 		= world.world;
			
			_bodyDef.position.Set(x / _scale, y / _scale);
			_bodyDef.angle 		= angle * (Math.PI/180);
			_bodyDef.isBullet 	= isBullet;
			
			_body = _world.CreateBody(_bodyDef);
			
			var newShape:b2Shape = addShape(0, 0, w, h, vertices, shape, group, friction, restitution, density, categoryBits, maskBits);
			updateMass();
			
			if(displayGraphic) this.graphic = displayGraphic;
			
			trace("created", shape, "body type:", newShape.GetType());
		}
//-------------------------------------------------------------------------------------------//

//--------------------------------------Public  Methods--------------------------------------//
		/**
		 * This allows you to add more shapes to a body. x and y values are offset from the center of the body.
		 * 
		 * @param x				Horizontal offset of the new TRIANGLE or POLYGON relative to the body.
		 * @param y				Vertical offset of the new TRIANGLE or POLYGON relative to the body.
		 * @param w				Width of rectangle or diameter of circle.
		 * @param h				Height of rectangle, ignored for all other shapes.
		 * @param vertices		Array of b2Vec2 objects from 3 to 8 points.
		 * @param shape			Type of shape Body.CIRCLE, Body.RECTANGLE, Body.Triangle or Body.POLYGON accepted.
		 * @param group			Collision group to add the body to.
		 * @param friction		The shape's friction coefficient, usually in the range [0,1].
		 * @param restitution	The shape's restitution (elasticity) usually in the range [0,1].
		 * @param density		The shape's density, usually in kg/m^2.
		 * @param categoryBits	!!! Still don't undestand this!!!
		 * @param maskBits		!!! Still don't undestand this!!!
		 * 
		 * @return 				The resulting shape.
		 */		 
		public function addShape(x:int=0, y:int=0, w:Number=20, h:Number=20, vertices:Array=null, shape:String="circle", group:int=0, friction:Number=0.3, restitution:Number=0.1, density:Number=1.0, categoryBits:Number=0x0000, maskBits:Number=0x0000):b2Shape
		{
			var shapeDef:b2ShapeDef;
			switch(shape)
			{
				case Body.CIRCLE:
				shapeDef = createCircle(w) as b2CircleDef;
				break;
				
				case Body.RECTANGLE:
				shapeDef = createSquare(w,h) as b2PolygonDef;
				break;
				
				default: // POLYGON
				shapeDef = createPolygon(vertices, x, y) as b2PolygonDef;
				break;
			}
			
			
			if(categoryBits !==0) 	shapeDef.filter.categoryBits 	= categoryBits;
			if(maskBits !==0) 		shapeDef.filter.maskBits 		= maskBits;
			if(group !== 0) 		shapeDef.filter.groupIndex 		= group;
			
			shapeDef.density 		= density;
			shapeDef.friction 		= friction;
			shapeDef.restitution 	= restitution;
			
			var b2shape:b2Shape = _body.CreateShape(shapeDef);
//			_body.SetMassFromShapes();
			return b2shape;
		}
		
		/**
		 * After adding shapes this needs to be called, apparently it's expensive hense it's removal from
		 * the addShape function.
		 * 
		 * @see #addShape()
		 */		
		public function updateMass():void
		{
			_body.SetMassFromShapes();
		}
		
		/**
		 * Same thing as constructing a body but should be with shortcut defaults to make it a static body.
		 * 
		 * @param world		The World object to add the body to.
		 * @param x			X location of the body (in normal dimensions).
		 * @param y			Y location of the body (in normal dimensions).
		 * @param w			Width of rectangle or radius of circle.
		 * @param h			Height of rectangle, ignored for all other shapes.
		 * @param shape		Type of shape Body.CIRCLE, Body.RECTANGLE, Body.Triangle or Body.POLYGON accepted.
		 * @param vertices	Array of b2Vec2 objects from 3 to 8 points.
		 * @param group		Collision group to add the body to.
		 * @param angle		Angle in degrees.
		 * @return 			Body object, use Body.body to retrieve the b2Body that is created.
		 * @see #Body()
		 */		
		public static function staticBody(world:World, x:int, y:int, w:Number=20, h:Number=20, shape:String="circle", vertices:Array=null, group:int=0, angle:Number=0, friction:Number=0.3, categoryBits:Number=0x0000, maskBits:Number=0x0000):Body
		{
			return new Body(world, x, y, w, h, shape, vertices, group, angle, false, friction, 0, 0, categoryBits, maskBits);
		}
		
		
		public static function complexBody(world:World, x:int, y:int, shapes:Array, group:int=0, angle:Number=0, isBullet:Boolean=false, friction:Number=0.3, restitution:Number=0.1, density:Number=1.0, maskBits:Number=0x0000, categoryBits:Number=0x0000):Body
		{
			var shapeObj:Object = shapes[0];
			var myBody:Body = new Body(world, x, y, shapeObj.width, shapeObj.height, shapeObj.shape, shapeObj.verticies, group, angle, isBullet, friction, restitution, density, categoryBits, maskBits);
			
			for(var i:int=1; i < shapes.length; i++)
			{
				shapeObj = shapes[i];
				myBody.addShape(shapeObj.x, shapeObj.y, shapeObj.width, shapeObj.height, shapeObj.vertices, shapeObj.shape, group, friction, restitution, density, categoryBits, maskBits);
			}
			
			myBody.updateMass();
			
			return myBody;
		}
//-------------------------------------------------------------------------------------------//

//--------------------------------------Private Methods--------------------------------------//
		private function createCircle(diameter:Number):b2ShapeDef
		{
			var circDef:b2CircleDef = new b2CircleDef();
				circDef.radius = (diameter / 2) / _scale;
			return circDef;
		}
		
		private function createSquare(w:Number, h:Number):b2ShapeDef
		{
			var polyDef:b2PolygonDef = new b2PolygonDef();
				polyDef.SetAsBox((w / 2) / _scale, (h / 2) / _scale);
			return polyDef;
		}
		
		private function createPolygon(vertices:Array, offsetX:int=0, offsetY:int=0):b2ShapeDef
		{
			var polyDef:b2PolygonDef = new b2PolygonDef();
				polyDef.vertexCount = vertices.length;
			for(var i:int=0; i < vertices.length; i++)
			{
				polyDef.vertices[i].Set((vertices[i].x + offsetX) / _scale, (vertices[i].y + offsetY) / _scale);
			}
			return polyDef;
		}
		
		private function updateGraphic(evt:Event):void
		{
			// World state position
		    var bodyPosition:b2Vec2 = _body.GetPosition();
		    var bodyRotation:Number = _body.GetAngle();
		 
		    // Sprite rotation based (0,0) correct for size by moving sprite before rotation.
		    // ie. rotation about the center of the sprite.
		    _graphic.rotation = 0; // If not, matrix starts wrong.
		    var m:Matrix = _graphic.transform.matrix;
		    m.identity();
		    m.tx = -_graphic.width / 2 ;
		    m.ty = -_graphic.height / 2;
		    m.rotate(bodyRotation); // Already in radians
		 
		    // Now set the position to the world position
		    m.tx += bodyPosition.x * _scale;
		    m.ty += bodyPosition.y * _scale;
		 
		    // ...and set the whole thing at once via the matrix.
		    // ie. Update the sprite.
		    _graphic.transform.matrix = m;
		}
//-------------------------------------------------------------------------------------------//		
	}
}