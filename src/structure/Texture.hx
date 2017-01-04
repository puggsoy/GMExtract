package structure;
import Util.*;
import haxe.ds.Vector;
import haxe.io.Bytes;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;
import sys.io.FileInput;
import sys.io.FileSeek;

class Texture
{
	static private var textures:Vector<BitmapData>;
	
	static private function loadTexture(f:FileInput, index:Int)
	{
		jump(f, findChunk(f, 'TXTR'));
		
		f.readInt32(); //name
		f.readInt32(); //length
		
		var offsetCount:Int = f.readInt32();
		
		if (index >= offsetCount || index < 0) throw 'Invalid texture index: $index';
		if (textures == null) textures = new Vector<BitmapData>(offsetCount);
		
		f.seek(4 * index, FileSeek.SeekCur); //get offset for this index
		f.seek(f.readInt32() + 4, FileSeek.SeekBegin); //go to the blob offset
		f.seek(f.readInt32(), FileSeek.SeekBegin); //go to PNG blob
		
		var pngLen:Int = Util.getPNGSize(f);
		var bytes:Bytes = Bytes.alloc(pngLen);
		f.readBytes(bytes, 0, pngLen);
		textures[index] = BitmapData.fromBytes(ByteArray.fromBytes(bytes));
		
		jumpBack(f);
	}
	
	static public function get(f:FileInput, index:Int):BitmapData
	{
		if (textures == null || textures[index] == null) loadTexture(f, index);
		
		return textures[index];
	}
}