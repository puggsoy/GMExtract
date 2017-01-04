package structure;
import Util.*;
import sys.io.FileInput;

class Chunk
{
	static public function read(f:FileInput, ?offset:Int):Chunk
	{
		if(offset != null) jump(f, offset);
		
		var name:String = f.readString(4);
		
		var c:Chunk =
			switch(name)
			{
				case 'SPRT':
					Sprt.read(f, offset);
				default:
					null;
			}
		
		if (offset != null) jumpBack(f);
		return c;
	}
	
	public var name(default, null):String;
	private var length:Int;
	
	public function new(name:String, length:Int)
	{
		this.name = name;
		this.length = length;
	}
}