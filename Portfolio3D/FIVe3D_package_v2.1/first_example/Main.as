package {

	import flash.display.StageScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// We import the FIVe3D classes needed.
	import five3D.display.DynamicText3D;
	import five3D.display.Scene3D;
	import five3D.display.Shape3D;
	import five3D.display.Sprite3D;
	import five3D.typography.HelveticaBold;
	import five3D.utils.Drawing;

	public class Main extends Sprite {

		public function Main() {
			
			// We define the Stage scale mode.
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// We create a new Scene3D named "scene", center it and add it to the display list.
			var scene:Scene3D = new Scene3D();
			scene.x = 300;
			scene.y = 200;
			addChild(scene);
			
			// We create a new Sprite3D named "sign", draw a rounded rectangle inside and add it to the "scene" display list.
			var sign:Sprite3D = new Sprite3D();
			sign.graphics3D.beginFill(0x000000);
			sign.graphics3D.drawRoundRect(-150, -150, 300, 300, 40, 40);
			sign.graphics3D.endFill();
			scene.addChild(sign);
			
			// We create a new Shape3D named "star", draw a star inside, place it and add it to the "sign" display list.
			var star:Shape3D = new Shape3D();
			Drawing.star(star.graphics3D, 20, 60, 50, 0, 0xD7006C);
			star.x = 120;
			star.y = -80;
			sign.addChild(star);
			
			// We create a new DynamicText3D named "hi", modify its properties, place it and add it to the "sign" display list.
			var hi:DynamicText3D = new DynamicText3D(HelveticaBold);
			hi.size = 50;
			hi.color = 0xFFFFFF;
			hi.text = "Hi!";
			hi.x = 88;
			hi.y = -110;
			sign.addChild(hi);
			
			// We create a new DynamicText3D named "world", modify its properties, place it and add it to the "sign" display list.
			var world:DynamicText3D = new DynamicText3D(HelveticaBold);
			world.size = 80;
			world.color = 0x666666;
			world.text = "World";
			world.x = -112;
			world.y = -34;
			sign.addChild(world);
			
			// We attribute a random value to the rotations on the X, Y and Z axes of the "sign".
			sign.rotationX = Math.random()*100-50;
			sign.rotationY = Math.random()*100-50;
			sign.rotationZ = Math.random()*100-50;
			
			// We register the class Main as a listener for the "enterFrame" event of the "star".
			star.addEventListener(Event.ENTER_FRAME, starEnterFrameHandler);
			
			// We register the class Main as a listener for the "click" mouse event of the "sign" and modify some of its mouse-related properties.
			sign.addEventListener(MouseEvent.CLICK, signClickHandler);
			sign.mouseChildren = false;
			sign.buttonMode = true;
		}

		private function starEnterFrameHandler(event:Event):void {
			// We rotate the "star".
			event.target.rotationZ++;
		}

		private function signClickHandler(event:MouseEvent):void {
			// We attribute a new random value to the rotations on the X, Y and Z axes of the "sign".
			event.target.rotationX = Math.random()*100-50;
			event.target.rotationY = Math.random()*100-50;
			event.target.rotationZ = Math.random()*100-50;
		}

	}

}