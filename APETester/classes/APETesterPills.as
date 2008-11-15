package {
	import com.huntandgather.utils.AverageFPS;
	import com.huntandgather.utils.Numbers;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.cove.ape.APEngine;
	import org.cove.ape.Group;
	import org.cove.ape.RectangleParticle;
	import org.cove.ape.Vector;
	
	[SWF(width="650", height="350", backgroundColor="#000000")] 
	public class APETesterPills extends Sprite
	{
		// physics stuff
		private var apeEngine	:APEngine;
		private var floor		:RectangleParticle;
		private var floorGroup	:Group;
		private var boxGroup	:Group;
		
		// my stuff
		private var _timer		:Timer;
		private var _boxes		:Array;
		private var _rate		:uint = 800;
		private var _gravity	:uint = 3;
		
		// methods
		public function APETesterPills()
		{
			stage.frameRate = 30;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(MouseEvent.CLICK, removeAllBoxes);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			init();
		}
		
		private function init():void
		{
			var fpsDisplay:AverageFPS = new AverageFPS();
			this.addChild(fpsDisplay);

			// Initialize the engine. The argument here is the time step value. 
			// Higher values scale the forces in the sim, making it appear to run
			// faster or slower. Lower values result in more accurate simulations.
			APEngine.init(.3);
			
			// set up the default diplay container
			APEngine.container = this;
			
			// gravity -- particles of varying masses are affected the same
			APEngine.addMasslessForce(new Vector(0, 3));
			
			floor = new RectangleParticle(stage.stageWidth/2, stage.stageHeight-50, stage.stageWidth-200, 80);
			floor.fixed = true;
			floor.friction = 0.3;
			floor.setStyle(0, 0, 0, 0xBADA55, 1);
			
			// apparently everything needs to be part of a group, which is handy for making tough shapes i suppose...
			floorGroup = new Group();
			floorGroup.addParticle(floor);
			
			// adding the box group, for the random shapes that will fall down
			// they also should collide off of eachother
			_boxes = new Array();
			addBox();
			
			APEngine.addGroup(floorGroup);
			
			
			this.addEventListener(Event.ENTER_FRAME, handleFrame);
			_timer = new Timer(_rate);
			_timer.addEventListener(TimerEvent.TIMER, addBox);
			_timer.start();
		}
		
		private function addBox(evt:Event=null):void
		{
			removeHidden();
			
			if(_boxes.length < 30)
			{
				var box:Box = new Box(Numbers.randRange(0x000001, 0xFFFFFE));
				box.x = Numbers.randRange(60, stage.stageWidth-120);
				box.y = 0;
				box.addCollidableList(_boxes);
				box.addCollidable(floorGroup);
				_boxes.push(box);
				APEngine.addGroup(box);
			}
		}
		
		private function removeHidden():void
		{
			for(var i:uint=0; i < _boxes.length; i++)
			{
				var box:Box = Box(_boxes[i]);
				if(box.x < 0 || box.x > stage.stageWidth || box.y > stage.stageHeight)
				{
					APEngine.removeGroup(box);
					_boxes.splice(i,1);
				}
			}
		}
		
		private function removeAllBoxes(evt:MouseEvent):void
		{
			while(_boxes.length > 1)
			{
				var box:Box = Box(_boxes[0]);
				APEngine.removeGroup(box);
				_boxes.splice(0,1);
			}
		}
		
		private function handleMouseMove(evt:MouseEvent):void
		{
			_rate = evt.stageX+100;
			_gravity = evt.stageY / 100;
			
			//_timer.delay = _rate;
			trace(_rate);
		}
		
		private function handleFrame(evt:Event):void
		{
			APEngine.step();
			APEngine.paint();
		}
	}
}
