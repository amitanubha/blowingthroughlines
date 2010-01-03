﻿package com.paperclipped.utils{	import flash.geom.Point;	/* one static method that returns an array of point objects representing a grid*/	public class PointGrid	{		public static function GRID(w:Number, h:Number, cols:Number, rows:Number):Array		{			var hoffset = Math.ceil(w/cols);			var voffset = Math.ceil(h/rows);			var pa:Array = new Array();			var p:Point;			var total = cols*rows;			var counter:Number = 0;			var vfoffset:Number = 0;			// do all the x coo and then the y			for(var i=0; i < total; i++){				p = new Point(0,0);				p.x= counter*hoffset;				p.y = vfoffset;				if(counter==cols-1){					counter=0;					vfoffset+=voffset;				}else{					counter++;				}				pa.push(p);			}			return pa;		}			public static function RANDOMIZE(ar:Array):Array		{			var i = ar.length;			if (i == 0) return new Array;			while (--i) {				var j = Math.floor(Math.random()*(i+1));				var tmp1 = ar[i];				var tmp2 = ar[j];				ar[i] = tmp2;				ar[j] = tmp1;			}			return ar;		}	}}