package com.paperclipped.geom
{
	/**
	 * So far only does a cosine curve well. The sine method is still in progress...
	 * @author Collin Reisdorf
	 */	
	public class SineWave
	{
		/**
		 * This draws a nice smooth cosine curve (bell curve).
		 * 
		 * @param time		The current time (x location) on the curve 0-1.
		 * @param freq		The number of troughs from 0 to 1.
		 * @param amp		The height of the wave.
		 * @param phase		Offset of the trough from 0.
		 * @return 			The height of the wave at a given time.
		 * @example			The following code sets the alpha for a sprite 
		 * 					based on it's x location on the stage: 
		 * 					<listing version="3.0">
		 * 					mySprite.alpha = SineWave.getCosHeight(myClip.x / stage.stageWidth, 1);
		 * 					</listing>
		 */		
		public static function getCosHeight(time:Number, amp:Number=1, freq:Number=2, phase:Number=0):Number
		{
			return amp * Math.cos((freq * ((time)*Math.PI)) + phase);
		}
		
		/**
		 * This draws a nice smooth sine wave (~ except backwards actually).
		 * 
		 * @param time		The current time (x location) on the curve 0-1.
		 * @param freq		The number of troughs from 0 to 1.
		 * @param amp		The height of the wave.
		 * @param phase		Offset of the trough from 25%.
		 * @return 			The height of the wave at a given time.
		 */		
		public static function getSineHeight(time:Number, freq:Number=2, amp:Number=1, phase:Number=0):Number
		{
			return amp * Math.sin((freq * ((time)*Math.PI)) + phase);
		}
	}
}