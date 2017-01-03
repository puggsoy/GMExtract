package;
import format.png.Data;
import format.png.Tools;
import format.png.Writer;
import haxe.ds.GenericStack;
import haxe.io.Bytes;
import haxe.io.Path;
import openfl.display.BitmapData;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;
import sys.io.FileSeek;

class Util
{
	/**
	 * Stack of locations to jump back to.
	 */
	static private var jumpStack:GenericStack<Int> = new GenericStack<Int>();
	
	/**
	 * Jumps to an offset in a FileInput, storing the current position. Don't forget to jumpBack() afterwards!
	 * @param	f The FileInput to jump through
	 * @param	o The offset to jump to
	 */
	static public function jump(f:FileInput, o:Int)
	{
		jumpStack.add(f.tell());
		f.seek(o, FileSeek.SeekBegin);
	}
	
	/**
	 * Jumps back to the last position stored from a jump() call.
	 * @param	f The FileInput to jump through
	 */
	static public function jumpBack(f:FileInput)
	{
		if (jumpStack.isEmpty()) throw 'No jump back address';
		
		f.seek(jumpStack.pop(), FileSeek.SeekBegin);
	}
	
	/**
	 * Finds the offset of the given chunk.
	 * @param	f      The FileInput to find the chunk in
	 * @param	chnkNm 4-character header of the chunk to find
	 * @return The offset of the chunk
	 */
	static public function findChunk(f:FileInput, chnkNm:String):Int
	{
		jump(f, 0);
		
		var chunk:String;
		do
		{
			chunk = f.readString(4);
			var len:Int = f.readInt32();
			
			if (chunk == 'FORM') continue;
			if (chunk == chnkNm) break;
			
			f.seek(len, FileSeek.SeekCur);
		}
		while (!f.eof());
		
		var ret:Int = f.tell() - 8;
		
		jumpBack(f);
		return ret;
	}
	
	/**
	 * Reads a string in the given FileInput. Removes the need to manually check the length.
	 * @param	f The FileInput to read from
	 * @param	o The offset of the string
	 * @return  The read string
	 */
	static public function getString(f:FileInput, o:Int):String
	{
		jump(f, o - 4);
		
		var len:Int = f.readInt32();
		var r:String = f.readString(len);
		
		jumpBack(f);
		
		return r;
	}
	
	/**
	 * Checks the size of a PNG file in a FileInput.
	 * @param	f The FileInput to read from
	 * @param	o The offset the PNG is at. If ommitted, simply reads from the current location
	 * @return  The size of the PNG
	 */
	static public function getPNGSize(f:FileInput, ?o:Int):Int
	{
		if (o == null) o = f.tell();
		jump(f, o);
		var be:Bool = f.bigEndian;
		f.bigEndian = true;
		
		var fst:Int = f.readInt32();
		var scd:Int = f.readInt32();
		if (fst != 0x89504E47 || scd != 0x0D0A1A0A) throw 'Invalid PNG file! Offset: ${f.tell()}';
		
		var chunk:String;
		var lenTotal:Int = 8;
		
		do
		{
			var chunkLen:Int = f.readInt32();
			chunk = f.readString(4);
			f.seek(chunkLen, FileSeek.SeekCur);
			f.readInt32(); //CRC
			lenTotal += chunkLen + 12;
		}
		while (chunk != 'IEND');
		
		f.bigEndian = be;
		jumpBack(f);
		
		return lenTotal;
	}
	
	/**
	 * Saves a BitmapData to a PNG file.
	 * @param	path The path of the resulting file
	 * @param	bmp  The BitmapData to save
	 */
	static public function savePNG(path:String, bmp:BitmapData)
	{
		if(Path.directory(path) != '') FileSystem.createDirectory(Path.directory(path));
		
		var dat:Data = Tools.build32ARGB(bmp.width, bmp.height, Bytes.ofData(bmp.getPixels(bmp.rect)));
		var o:FileOutput = File.write(path);
		new Writer(o).write(dat);
		o.close();
	}
	
	/**
	 * Saves bytes to a file.
	 * @param	path The path of the resulting file
	 * @param	b    The bytes to save
	 */
	static public function saveBytes(path:String, b:Bytes)
	{
		if (Path.directory(path) != '') FileSystem.createDirectory(Path.directory(path));
		
		var fo:FileOutput = File.write(path);
		fo.write(b);
		fo.close();
	}
}