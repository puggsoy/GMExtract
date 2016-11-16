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
		
		for (i in 0...sprt.addressCount)
		{
			sprt.sprites[i] = Sprite.read(f, sprt.addresses[i]);
		}
		
		if (offset != null) jumpBack(f);
		return sprt;
	}
	
	private var sprites:Vector<Sprite>;
	
	public function new(name:String, length:Int, addressCount:Int) 
	{
		super(name, length, addressCount);
		sprites = objects;
	}
}