package structure;
import haxe.ds.Vector;
import structure.Chunk;
import sys.io.FileInput;

class ListChunk<T> extends structure.Chunk
{
	private var offsetCount:Int;
	private var offsets:Vector<Int>;
	private var objects:Vector<T>;
	
	public function new(name:String, length:Int, offsetCount:Int) 
	{
		super(name, length);
		
		this.offsetCount = offsetCount;
		offsets = new Vector<Int>(offsetCount);
		objects = new Vector<T>(offsetCount);
	}
}