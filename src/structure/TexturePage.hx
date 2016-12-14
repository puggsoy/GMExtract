package structure;
import sys.io.FileInput;

class TexturePage
{
	static public function read(f:FileInput, ?offset:Int):Sprite
	{
		if (offset != null) jump(f, offset);
		
		var t:TexturePage = new TexturePage();
		
		t.x = f.readInt32();
		t.y = f.readInt32();
		t.width = f.readInt32();
		t.height = f.readInt32();
		t.renderOffsetX = f.readInt32();
		t.renderOffsetY = f.readInt32();
		t.boundingX = f.readInt32();
		t.boundingY = f.readInt32();
		t.boundingWidth = f.readInt32();
		t.boundingHeight = f.readInt32();
		t.spriteSheetID = f.readInt32();
		
		if (offset != null) jumpBack(f);
		
		return s;
	}
	
	private var x:Int;
	private var y:Int;
	private var width:Int;
	private var height:Int;
	private var renderOffsetX:Int;
	private var renderOffsetY:Int;
	private var boundingX:Int;
	private var boundingY:Int;
	private var boundingWidth:Int;
	private var boundingHeight:Int;
	private var spriteSheetID:Int;
	
	public function new()
	{}
}