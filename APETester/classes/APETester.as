package {
	import com.huntandgather.utils.AverageFPS;
	import com.huntandgather.utils.Numbers;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.cove.ape.APEngine;
	import org.cove.ape.Group;
	import org.cove.ape.RectangleParticle;
	import org.cove.ape.SpringConstraint;
	
	[SWF(width="1100", height="800", backgroundColor="#000000")] 
	public class APETester extends Sprite
	{
		// physics stuff
		private var _apeEngine	:APEngine;
		private var _wallGroup	:Group;
		private var _boxGroup	:Group;
		// walls for edges of stage (actually edges of keywords)
		private var _wallT		:RectangleParticle;
		private var _wallL		:RectangleParticle;
		private var _wallR		:RectangleParticle;
		private var _wallB		:RectangleParticle;
		private var _keyword	:RectangleParticle;		
		private var checkCol	:Boolean = false;
		
		
		// methods
		public function APETester()
		{
			stage.frameRate = 30;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			init();
		}
		
		private function init():void
		{
			var fpsDisplay:AverageFPS = new AverageFPS();
			this.addChild(fpsDisplay);

			// Initialize the engine. The argument here is the time step value. 
			// Higher values scale the forces in the sim, making it appear to run
			// faster or slower. Lower values result in more accurate simulations.
			APEngine.init(1/4);
			
			// set up the default diplay container
			APEngine.container = this;
			
			// gravity -- particles of varying masses are affected the same
			//APEngine.addMasslessForce(new Vector(0, 3));
			_wallT = new RectangleParticle(stage.stageWidth/2, -90, stage.stageWidth, 200);
			_wallT.fixed = true;
			_wallT.friction = 0;
			_wallT.setStyle(0, 0, 0, 0xBADA55, 1);
			
			_wallB = new RectangleParticle(stage.stageWidth/2, stage.stageHeight+90, stage.stageWidth, 200);
			_wallB.fixed = true;
			_wallB.friction = 0;
			_wallB.setStyle(0, 0, 0, 0xBADA55, 1);
			
			_wallL = new RectangleParticle(-90, stage.stageHeight/2, 200, stage.stageHeight);
			_wallL.fixed = true;
			_wallL.friction = 0;
			_wallL.setStyle(0, 0, 0, 0xBADA55, 1);
			
			_wallR = new RectangleParticle(stage.stageWidth+90, stage.stageHeight/2, 200, stage.stageHeight);
			_wallR.fixed = true;
			_wallR.friction = 0;
			_wallR.setStyle(0, 0, 0, 0xBADA55, 1);
			
			_keyword = new RectangleParticle(stage.stageWidth/2, stage.stageHeight/2, 300, 200);
			_keyword.fixed = true;
			_keyword.friction = 0;
			_keyword.setStyle(0, 0, 0, 0xBADA55, 1);
			
			// apparently everything needs to be part of a group, which is handy for making tough shapes i suppose...
			_wallGroup = new Group();
			_wallGroup.addParticle(_wallB);
			_wallGroup.addParticle(_wallT);
			_wallGroup.addParticle(_wallL);
			_wallGroup.addParticle(_wallR);
			_wallGroup.addParticle(_keyword);
			// adding the box group, for the random shapes that will fall down
			// they also should collide off of eachother
			_boxGroup	= new Group();
			_boxGroup.collideInternal = true;
			
			_boxGroup.addCollidable(_wallGroup);
			addBox();
			
			APEngine.addGroup(_boxGroup);
			APEngine.addGroup(_wallGroup);
			
			
			this.addEventListener(Event.ENTER_FRAME, handleFrame);
			
			removeAllBoxes();
		}
		
		private function addBox():void
		{
			if(_boxGroup.particles.length <= 10)
			{
			    //boxGroup.cleanup()
			    
				// check to see if the boxes have room, and if so, add another box
				var randLoc:Point = new Point(Numbers.randRange((stage.stageWidth - _keyword.width)/2, (stage.stageWidth + _keyword.width)/2),
											  Numbers.randRange((stage.stageHeight - _keyword.height)/2, (stage.stageHeight + _keyword.height)/2));
											  
//				var randLoc:Point = new Point(Numbers.randRange(100, stage.stageWidth - 100),
//											  Numbers.randRange(100, stage.stageHeight - 100));
				
				var box:RectangleParticle = new RectangleParticle(randLoc.x, randLoc.y, Numbers.randRange(100, 200), Numbers.randRange(100, 200));
				box.mass = 0.1;
				box.friction = 0;
				box.elasticity = 0;
				
				box.alwaysRepaint = true;
				_boxGroup.addConstraint(new SpringConstraint(_keyword, box, 0.005, false));
				_boxGroup.addParticle(box);
			}
			
			
		}
		
		private function checkCollisions():Boolean
		{
			var colliding:Boolean = false;
			//var startTime:Number = flash.utils.getTimer()
			var numObjects:uint = _boxGroup.particles.length;
			for( var i:uint = 0; i < numObjects; i++)
			{
				var box:RectangleParticle  = RectangleParticle(_boxGroup.particles[i]);
				for( var k:uint = 0; k < numObjects; k++)
				{
					if(k != i)
					{
						
						if(box.sprite.hitTestObject(RectangleParticle(_boxGroup.particles[k]).sprite))
						{
							if(box.sprite.scaleX < .4)
							{
								box.px = Numbers.randRange(150, stage.stageWidth - 150);
								box.py = Numbers.randRange(150, stage.stageHeight - 150);
							}else
							{
								box.sprite.scaleX -= 0.01;
								box.sprite.scaleY -= 0.01;
								
								box.px += Numbers.randRange(-10, 10);
								box.py += Numbers.randRange(-10, 10);
							}
							
							box.width = box.sprite.width + 4;
							box.height = box.sprite.height + 4;
							
							colliding = true;
						}
					}
				}
			}
			
			//trace("check collisions took:", (flash.utils.getTimer() - startTime));
			return colliding;
		}
		
		private function removeAllBoxes(evt:MouseEvent=null):void
		{
			checkCol = false;
			this.removeEventListener(Event.ENTER_FRAME, handleFrame);
			
			
			_boxGroup.cleanup();
			
			while(_boxGroup.constraints.length > 1) _boxGroup.removeConstraint(	_boxGroup.constraints[0]	);
			while(_boxGroup.particles.length > 1) 	_boxGroup.removeParticle(	_boxGroup.particles[0]		);
			
			var timer:Timer = new Timer(2000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void{ checkCol = true;});
			timer.start();
			//flash.utils.setTimeout(function():void{timer.start();}, 2000);
			stage.addEventListener(MouseEvent.CLICK, removeAllBoxes);
			this.addEventListener(Event.ENTER_FRAME, handleFrame);
		}
		
		private function handleFrame(evt:Event):void
		{
			APEngine.step();
			APEngine.paint();
			addBox();
			//trace(boxGroup.
			
			if(checkCol)
			{
				if(!checkCollisions())
				{
					checkCol = false;
					trace("all done arranging");
					this.removeEventListener(Event.ENTER_FRAME, handleFrame);
					getLocations();
				}
			}
		}
		
		private function getLocations():void
		{
			var boxes:Array = new Array();
			var boxSprite:Sprite;
			for(var i:uint=0; i < _boxGroup.particles.length; i++)
			{
				boxSprite = _boxGroup.particles[i].sprite;
				boxes.push({loc:new Point(boxSprite.x, boxSprite.y), scale:boxSprite.scaleX});
			}
			
			trace("now we have the boxes:", boxes)
		}
	}
}
