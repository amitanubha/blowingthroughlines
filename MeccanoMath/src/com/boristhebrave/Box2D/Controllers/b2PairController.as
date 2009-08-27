﻿/*
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

import Box2D.Common.Math.*;
import Box2D.Dynamics.*;


/// Base class for controllers. Controllers are a convience for encapsulating common
/// per-step functionality
public class b2PairController extends b2Controller
{
	public var m_body1:b2Body;
	public var m_body2:b2Body;
	
	/// Get the anchor point on body1 in world coordinates.
	public virtual function GetAnchor1():b2Vec2{return null};
	/// Get the anchor point on body1 in world coordinates.
	public virtual function SetAnchor1(v:b2Vec2):void{};
	/// Get the anchor point on body2 in world coordinates.
	public virtual function GetAnchor2():b2Vec2{return null};
	/// Set the anchor point on body1 in world coordinates.
	public virtual function SetAnchor2(v:b2Vec2):void{};
	
	
	/// Get the first body attached to this joint.
	public function GetBody1():b2Body
	{
		return m_body1;
	}
	
	/// Get the first body attached to this joint.
	public function SetBody1(b:b2Body):void
	{
		m_body1 = b;
	}
	
	/// Get the second body attached to this joint.
	public function GetBody2():b2Body
	{
		return m_body2;
	}
	/// Get the second body attached to this joint.
	public function SetBody2(b:b2Body):void
	{
		m_body2 = b;
	}
}

}