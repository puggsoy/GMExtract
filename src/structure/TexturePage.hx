package structure;
import Util.*;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import sys.io.FileInput;

class TexturePage
{
	static public function read(f:FileInput, ?offset:Int):TexturePage
	{
		if (offset != null) jump(f, offset);
		
		var t:TexturePage = new TexturePage();
		
		t.x = f.readInt16();
		t.y = f.readInt16();
		t.width = f.readInt16();
		t.height = f.readInt16();
		t.renderX = f.readInt16();
		t.renderY = f.readInt16();
		t.boundingX = f.readInt16();
		t.boundingY = f.readInt16();
		t.boundingWidth = f.readInt16();
		t.boundingHeight = f.readInt16();
		t.spriteSheetID = f.readInt16();
		
		if (offset != null) jumpBack(f);
		
		return t;
	}
	
	private var x:Int;
	private var y:Int;
	private var width:Int;
	private var height:Int;
	private var renderX:Int;
	private var renderY:Int;
	private var boundingX:Int;
	private var boundingY:Int;
	private var boundingWidth:Int;
	private var boundingHeight:Int;
	private var spriteSheetID:Int;
	
	public function new() {}
	
	public function getBitmap(f:FileInput):BitmapData
	{
		var source:BitmapData = Texture.get(f, spriteSheetID);
		var ret:BitmapData = new BitmapData(boundingWidth, boundingHeight, true, 0);
		ret.copyPixels(source, new Rectangle(x, y, width, height), new Point(renderX, renderY));
		
		return ret;
	}
}