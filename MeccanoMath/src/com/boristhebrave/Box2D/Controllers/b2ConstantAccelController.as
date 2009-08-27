/*
* Copyright (c) 2006-2007 Adam Newgas
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

package com.boristhebrave.Box2D.Controllers{

import Box2D.Common.Math.*;
import Box2D.Common.*;
import Box2D.Collision.Shapes.*;
import Box2D.Dynamics.*;


/// Applies a force every frame
public class b2ConstantAccelController extends b2MultiController
{	
	/// The acceleration to apply
	public var A:b2Vec2 = new b2Vec2(0,0);
	
	public override function Step(timestep:Number):void{
		var smallA:b2Vec2 = new b2Vec2(A.x*timestep,A.y*timestep);
		for(var i:int=0;i<m_bodies.length;i++){
			var body:b2Body = m_bodies[i];
			if(body.IsSleeping())
				continue;
			//Am being lazy here
			body.m_linearVelocity.x +=smallA.x;
			body.m_linearVelocity.y +=smallA.y;
		}
	}
	
	public static function FromBodies(bodies:Array, A:b2Vec2 = null):b2ConstantAccelController
	{
		var c:b2ConstantAccelController = new b2ConstantAccelController();
		for(var i=0;i<bodies.length;i++){
			c.AddBody(bodies[i]);
		}
		if(A!=null)
			c.A.SetV(A);
		return c;
	}
}

}