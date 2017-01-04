package structure;
import Util.*;
import structure.ListChunk;
import sys.io.FileInput;

class Sprt extends structure.ListChunk<Sprite>
{
	static public function read(f:FileInput, ?offset:Int):Sprt
	{
		if (offset != null) jump(f, offset);
		else jump(f, findChunk(f, 'SPRT'));
		
		var sprt:Sprt = new Sprt(f.readString(4), f.readInt32(), f.readInt32());
		
		if (sprt.name != 'SPRT') throw 'Trying to read SPRT at incorrect offset!';
		
		for (i in 0...sprt.offsetCount)
		{
			sprt.offsets[i] = f.readInt32();
			sprt.objects[i] = Sprite.read(f, sprt.offsets[i]);
		}
		
		if (offset != null) jumpBack(f);
		return sprt;
	}
	
	public function new(name:String, length:Int, offsetCount:Int) 
	{
		super(name, length, offsetCount);
	}
	
	public function extractAll(f:FileInput, outDir:String)
	{
		for (i in 0...offsetCount)
		{
			objects[i].extract(f, outDir);
		}
	}
}