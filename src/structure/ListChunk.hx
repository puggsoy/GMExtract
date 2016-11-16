package structure;
import haxe.ds.Vector;
import structure.Chunk;

class ListChunk<T> extends structure.Chunk
{
	private var addressCount:Int;
	private var addresses:Vector<Int>;
	private var objects:Vector<T>;
	
	public function new(name:String, length:Int, addressCount:Int) 
	{
		super(name, length);
		
		this.addressCount = addressCount;
		addresses = new Vector<Int>(addressCount);
		objects = new Vector<T>(addressCount);
	}
}