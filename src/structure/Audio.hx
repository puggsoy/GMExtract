package structure;
import haxe.io.Bytes;
import sys.io.FileInput;
import sys.io.FileSeek;
import Util.*;

class Audio
{
	static public function get(f:FileInput, index:Int):Bytes
	{
		jump(f, findChunk(f, 'AUDO'));
		
		f.readInt32(); //name
		f.readInt32(); //length
		
		var offsetCount:Int = f.readInt32();
		
		if (index >= offsetCount || index < 0) throw 'Invalid audio index: $index';
		
		f.seek(4 * index, FileSeek.SeekCur); //get offset for this index
		f.seek(f.readInt32(), FileSeek.SeekBegin); //go to offset
		var wavLen:Int = f.readInt32();
		var ret:Bytes = f.read(wavLen);
		
		jumpBack(f);
		
		return ret;
	}
}