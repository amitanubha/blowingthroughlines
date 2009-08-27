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


/// Base class for controllers. Controllers are a convience for encapsulating common
/// per-step functionality
public class b2Controller
{
	public var m_next:b2Controller;
	public var m_prev:b2Controller;
		
	public function GetNext():b2Controller{return m_next;}
	public function GetPrev():b2Controller{return m_prev;}
	
	public virtual function Step(timestep:Number):void {}
		
	public virtual function Draw(debugDraw:b2DebugDraw):void {}
}

}