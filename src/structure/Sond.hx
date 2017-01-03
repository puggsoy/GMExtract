package structure;
import haxe.ds.Vector;
import structure.ListChunk;
import sys.io.FileInput;
import Util.*;

class Sond extends structure.ListChunk<Sound>
{
	static public function read(f:FileInput, ?offset:Int):Sond
	{
		if (offset != null) jump(f, offset);
		else jump(f, findChunk(f, 'SOND'));
		
		var sond:Sond = new Sond(f.readString(4), f.readInt32(), f.readInt32());
		
		if (sond.name != 'SOND') throw 'Trying to read SPRT at incorrect offset!';
		
		for (i in 0...sond.offsetCount)
		{
			sond.offsets[i] = f.readInt32();
			sond.objects[i] = Sound.read(f, sond.offsets[i]);
		}
		
		if (offset != null) jumpBack(f);
		return sond;
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