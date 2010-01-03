﻿package com.paperclipped.pv3d.utils{		import flash.geom.Point;		import org.papervision3d.cameras.*;	import org.papervision3d.core.math.Matrix3D;	import org.papervision3d.core.math.Number3D;	import org.papervision3d.objects.DisplayObject3D;			public class Conversion3d	{		public function Conversion3d()		{			// Blank		}				public static function convertTo2DCoords(o:DisplayObject3D, camera:Camera3D, stageW:Number=0, stageH:Number=0, offsetX:Number = 0, offsetY:Number = 0):Point			// + stageW and stage can be left 0 if you want to get the xy from the center of the stage;		{			var view:Matrix3D = o.view;			var persp:Number = (camera.focus * camera.zoom) / (camera.focus + view.n34);			if (stageW!=0 && stageH!=0){				return new Point(stageW/2 + ((view.n14 * persp) + offsetX), (stageH/2 + (view.n24 * persp) + offsetY));			}else{				return new Point((view.n14 * persp) + offsetX, (view.n24 * persp) + offsetY);			}		} 				public static function convertTo3DCoords(p:Point,camera:Camera3D, stageW:Number, stageH:Number, z:Number=0):Number3D // This only works if z = 0		{			var tempX:Number	= p.x - (stageW/2);			var tempY:Number	= (stageH/2) - p.y;			var persp:Number	= (camera.focus / camera.zoom) * (camera.focus + z);			var p3D:Number3D	= new Number3D();				p3D.x	= tempX*persp;				p3D.y	= tempY*persp;				p3D.z	= z;			return p3D;		} 				public static function scaleDO3D(scale:Number):DisplayObject3D		{			var DO3D:DisplayObject3D	= new DisplayObject3D;				DO3D.scale	= scale;			return DO3D;				}	}}