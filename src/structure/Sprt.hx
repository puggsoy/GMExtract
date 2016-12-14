package structure;
import haxe.ds.Vector;
import structure.ListChunk;
import sys.io.FileInput;
import Util.*;

class Sprt extends structure.ListChunk<Sprite>
{
	static public function read(f:FileInput, ?offset:Int):Sprt
	{
		if (offset != null) jump(f, offset);
		
		var sprt:Sprt = new Sprt(f.readString(4), f.readInt32(), f.readInt32());
		
		if (sprt.name != 'SPRT') throw 'Trying to read SPRT at incorrect offset!';
		
		for (i in 0...sprt.offsetCount)
		{
			sprt.offsets[i] = f.readInt32();
			sprt.sprites[i] = Sprite.read(f, sprt.offsets[i]);
		}
		
		if (offset != null) jumpBack(f);
		return sprt;
	}
	
	public var sprites(default, null):Vector<Sprite>;
	
	public function new(name:String, length:Int, offsetCount:Int) 
	{
		super(name, length, offsetCount);
		sprites = objects;
	}
}