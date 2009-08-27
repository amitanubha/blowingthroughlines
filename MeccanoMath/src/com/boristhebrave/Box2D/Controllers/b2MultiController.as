/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
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


import Box2D.Dynamics.*;


/// Base class for multi-controllers, which control multiple bodies at once
public class b2MultiController extends b2Controller
{
	var m_bodies:Array = [];
	
	/// Wake all the bodies being controlled.
	/// You should call this if you change the contollers parameters
	public function WakeBodies():void
	{
		for(var i:int=0;i<m_bodies.length;i++){
			m_bodies[i].WakeUp();
		}
	}
	
	/// Creates an instance of the controller and adds the provided bodies
	/// A similar method should be implemented for each controller
	public static function FromBodies(bodies:Array):b2MultiController
	{
		var c:b2MultiController = new b2MultiController();
		for(var i=0;i<bodies.length;i++){
			c.AddBody(bodies[i]);
		}
		return c;
	}
	
	public virtual function AddBodies(bodies:Array):void{
		for(var i=0;i<bodies.length;i++){
			AddBody(bodies[i]);
		}
	}
	
	/// Adds a body to the controller
	public virtual function AddBody(body:b2Body):void
	{
		m_bodies.push(body);
	}
	
	/// Removes an added body from the controller
	public virtual function RemoveBody(body:b2Body):void
	{
		m_bodies= m_bodies.filter(function(obj){return obj!=body});
	}
	
	/// Returns an array of bodies currently being controlled
	public virtual function GetBodies():Array
	{
		return m_bodies;
	}
	
}

}