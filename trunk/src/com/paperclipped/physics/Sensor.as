package com.paperclipped.physics
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2PolygonDef;
	
	import flash.display.DisplayObject;

	public class Sensor extends Body
	{
//-----------------------------------------Variables-----------------------------------------//
//-------------------------------------------------------------------------------------------//

//------------------------------------------Getters------------------------------------------//
//-------------------------------------------------------------------------------------------//

//------------------------------------------Setters------------------------------------------//
//-------------------------------------------------------------------------------------------//

//--------------------------------------Public  Methods--------------------------------------//
		public function Sensor(world:World, x:int, y:int, w:Number=20, h:Number=20, shape:String="circle", vertices:Array=null, group:int=0, angle:Number=0, isBullet:Boolean=false, friction:Number=0.3, restitution:Number=0.1, density:Number=1.0, categoryBits:Number=0x0000, maskBits:Number=0x0000, displayGraphic:DisplayObject=null)
		{
			super(world, x, y, w, h, shape, vertices, group, angle, isBullet, friction, restitution, density, true, categoryBits, maskBits, displayGraphic);
		}
		public static function staticSensor(world:World, x:int, y:int, w:Number=20, h:Number=20, shape:String="circle", vertices:Array=null, group:int=0, angle:Number=0, friction:Number=0.3, categoryBits:Number=0x0000, maskBits:Number=0x0000):Sensor
		{
			var sensor:Sensor = new Sensor(world, x, y, w, h, shape, vertices, group, angle, false, friction, 0, 0, categoryBits, maskBits);
				sensor.body.SetStatic();
			return sensor;
		}
//		public static function complexSensor(world:World, x:int, y:int, shapes:Array, group:int=0, angle:Number=0, isBullet:Boolean=false, friction:Number=0.3, restitution:Number=0.1, density:Number=1.0, maskBits:Number=0x0000, categoryBits:Number=0x0000):Sensor
//		{
//			var shapeObj:Object = shapes[0];
//			var myBody:Sensor = new Sensor(world, x, y, shapeObj.width, shapeObj.height, shapeObj.shape, shapeObj.verticies, group, angle, isBullet, friction, restitution, density, categoryBits, maskBits);
//			
//			for(var i:int=1; i < shapes.length; i++)
//			{
//				shapeObj = shapes[i];
//				myBody.addShape(shapeObj.x, shapeObj.y, shapeObj.width, shapeObj.height, shapeObj.vertices, shapeObj.shape, group, friction, restitution, density, categoryBits, maskBits);
//			}
//			
//			myBody.updateMass();
//			
//			return myBody;
//		}
//-------------------------------------------------------------------------------------------//

//--------------------------------------Private Methods--------------------------------------//
		override protected function createCircle(diameter:Number):b2CircleDef
		{
			var circDef:b2CircleDef = super.createCircle(diameter);
			circDef.isSensor = true;
			return circDef;
		}
		
		override protected function createSquare(w:Number, h:Number):b2PolygonDef
		{
			var polyDef:b2PolygonDef = super.createSquare(w, h);
			polyDef.isSensor = true;
			return polyDef;
		}
		
		override protected function createPolygon(vertices:Array, offsetX:int=0, offsetY:int=0):b2PolygonDef
		{
			var polyDef:b2PolygonDef = super.createPolygon(vertices, offsetX, offsetY);
			polyDef.isSensor = true;
			return polyDef;
		}
//-------------------------------------------------------------------------------------------//
	}
}