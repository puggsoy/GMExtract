package structure;
import haxe.ds.Vector;
import haxe.io.Bytes;
import haxe.io.Path;
import sys.io.FileInput;
import Util.*;

class Sprite
{
	static public function read(f:FileInput, ?offset:Int):Sprite
	{
		if (offset != null) jump(f, offset);
		
		var s:Sprite = new Sprite();
		
		s.name = getString(f, f.readInt32());
		s.width = f.readInt32();
		s.height = f.readInt32();
		s.left = f.readInt32();
		s.right = f.readInt32();
		s.bottom = f.readInt32();
		s.top = f.readInt32();
		s.unk = new Vector<Int>(3); s.unk[0] = f.readInt32(); s.unk[1] = f.readInt32(); s.unk[2] = f.readInt32();
		s.bBoxMode = f.readInt32();
		s.sepMasks = f.readInt32();
		s.originX = f.readInt32();
		s.originY = f.readInt32();
		s.textureCount = f.readInt32();
		s.textureOffsets = new Vector<Int>(s.textureCount);
		
		for (i in 0...s.textureCount)
		{
			s.textureOffsets[i] = f.readInt32();
		}
		
		if (offset != null) jumpBack(f);
		
		return s;
	}
	
	private var name:String;
	private var width:Int;
	private var height:Int;
	private var left:Int;
	private var right:Int;
	private var bottom:Int;
	private var top:Int;
	private var unk:Vector<Int>;
	private var bBoxMode:Int;
	private var sepMasks:Int;
	private var originX:Int;
	private var originY:Int;
	private var textureCount:Int;
	private var textureOffsets:Vector<Int>;
	
	public function new() {}
	
	public function extract(f:FileInput, outDir:String)
	{
		for (i in 0...textureCount)
		{
			var outPath:String = Path.join([outDir, name, name + '_$i.png']);
			var tpag:TexturePage = TexturePage.read(f, textureOffsets[i]);
			
			Sys.println('Saving $outPath');
			savePNG(outPath, tpag.getBitmap(f));
		}
	}
}