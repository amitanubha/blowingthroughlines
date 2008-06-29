// by Zack Jordan, 2008
// { P I X E L W E L D E R S }
// pixelwelders.com
package com.pixelwelders.textcloud
{
	import five3D.display.DynamicText3D;
	import five3D.display.Sprite3D;
	
	import fl.motion.easing.Back;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import gs.TweenLite;

	public class MotifCollection3D extends Sprite3D
	{
		
		private var string				: String;			// original String
		private var splitString			: Array;			// split from original String
		private var typography			: Class;			// font
		private var size				: Number; 			// size of each letter
		private var color				: uint;				// color of this word
		private var collectionWidth		: Number;			// width of this Sprite3D
		
		private var dynamicText3Ds		: Array;			// collection of DynamicText3Ds- one for every letter in splitString
		private var xPositions			: Dictionary;		// Dictionary for storing x positions of all DynamicText3Ds
		
		public var assembled			: Boolean;
		
		// return the width of all DynamicText3Ds
		public function get textWidth(): Number
		{
			return collectionWidth;
		}
		
		public function MotifCollection3D( string:String, typography:Class, size:Number, color:uint )
		{
			super();
			
			this.string = string;
			this.typography = typography;
			this.size = size;
			this.color = color;
			
			splitString = string.split( "" );
			
			create();
		}
		
		// === S E T U P ===
		private function create(): void
		{
			dynamicText3Ds = new Array( splitString.length );
			xPositions = new Dictionary();
			var currentLetterPosition:Number = 0;
			
			for ( var i:int = 0; i < splitString.length; i++ )
			{
				var m:DynamicText3D = new DynamicText3D( typography );
				m.size = size;
				m.color = color;
				m.text = splitString[ i ];
				m.x = currentLetterPosition;
				xPositions[ m ] = currentLetterPosition; 
				
				this.addChild( m );
				dynamicText3Ds[ i ] = m;
				
				var letterWidth:Number = typography.__widths[ splitString[ i ] ] * ( size / 100 );
				
				currentLetterPosition += letterWidth;
			}
			
			assembled = true;
		}
		
		// === A P I ===
		public function assemble( seconds:Number = 4, ease:Function = null ): void
		{
			ease = ease == null ? Back.easeInOut : ease
			
			for ( var i:int = 0; i < dynamicText3Ds.length; i++ )
			{
				var t:DynamicText3D = dynamicText3Ds[ i ];
				TweenLite.to( 
					t, 
					Math.random() * ( seconds / 2 ) + seconds / 2, 
					{ alpha:1, rotationX:0, rotationY:0, rotationZ:0, z:0, y:0, x:xPositions[ t ], ease:ease } 
				);
			}
			
			assembled = true;
		}
		
		// 'distance' is the furthest the letters can travel from the ( 0, 0, 0 ) point of this Sprite3D
		public function explode( seconds:Number = 4, ease:Function = null, distance:Number = 600 ): void
		{
			ease = ease == null ? Back.easeInOut : ease;
			
			for ( var i:int = 0; i < dynamicText3Ds.length; i++ )
			{
				var t:DynamicText3D = dynamicText3Ds[ i ];
				TweenLite.to( 
					t, 
					Math.random() * ( seconds / 2 ) + seconds / 2, 
					{ 
						x:-this.x + Math.random() * distance - distance / 2, 
						y:-this.y + Math.random() * distance - distance / 2, 
						z:-this.z + Math.random() * distance - distance / 2, 
						rotationX:Math.random() * 150 - 75, 
						rotationY:Math.random() * 150 - 75, 
						rotationZ:Math.random() * 150 - 75, 
						alpha:1, 
						ease:ease 
					} 
				);
			}
			
			assembled = false;
			
		}
		
	}
}