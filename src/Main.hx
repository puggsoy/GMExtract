package;

import easyconsole.Begin;
import easyconsole.End;
import format.png.Data;
import format.png.Reader;
import format.png.Tools;
import format.png.Writer;
import haxe.ds.Vector;
import haxe.io.Bytes;
import haxe.io.Path;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;
import sys.io.FileSeek;

class Main
{
	private var txtrOff:Int;
	private var sheets:Vector<BitmapData>;
	private var outDir:String;
	
	private var exclude:Bool = true;
	
	static function main()
	{
		new Main();
	}
	
	public function new() 
	{
		var pName:String = Path.withoutExtension(Path.withoutDirectory(Sys.executablePath()));
		Begin.init();
		Begin.usage = 'Usage: $pName inFile outDir [-e]\n    inFile: The data.win file to extract from\n    outDir: The folder to save the extracted files to\n    [-e]: Optionally exclude consecutive duplicates';
		Begin.functions = [null, null, checkArgs];
		Begin.parseArgs();
	}
	
	private function checkArgs()
	{
		var inFile:String = Begin.args[0];
		
		if (!FileSystem.exists(inFile))
		{
			End.terminate(1, "inFile must exist!");
		}
		
		outDir = Begin.args[1];
		
		if (FileSystem.exists(outDir) && !FileSystem.isDirectory(outDir))
		{
			End.terminate(1, "outDir must be a directory!");
		}
		
		checkOptions(Begin.args.slice(2));
		
		outDir = Path.addTrailingSlash(outDir);
		
		//Start working
		extract(inFile);
		
		End.terminate(0, "Done");
	}
	
	private function checkOptions(options:Array<String>)
	{
		for (o in options)
		{
			switch(o)
			{
				case '-i':
					exclude = false;
			}
		}
	}
	
	private function extract(fPath:String)
	{
		var f:FileInput = File.read(fPath);
		f.bigEndian = false;
		f.seek(0, FileSeek.SeekEnd);
		var fLen:Int = f.tell();
		f.seek(0, FileSeek.SeekBegin);
		
		var sprtOff:Int = 0;
		var tpagOff:Int = 0;
		txtrOff = 0;
		
		var chName:String;
		var len:Int;
		
		do
		{
			chName = f.readString(4);
			len = f.readInt32();
			
			if (chName == 'FORM') continue;
			if (chName == 'SPRT') sprtOff = f.tell() - 4;
			if (chName == 'TPAG') tpagOff = f.tell() - 4;
			if (chName == 'TXTR') txtrOff = f.tell() - 4;
			
			f.seek(len, FileSeek.SeekCur);
		}
		while (f.tell() < fLen);
		
		initSheets(f, txtrOff);
		
		extractSprites(f, sprtOff);
		
		f.close();
	}
	
	private function initSheets(f:FileInput, off:Int)
	{
		var origOff:Int = f.tell();
		f.seek(off, FileSeek.SeekBegin);
		
		var len:Int = f.readInt32();
		var num:Int = f.readInt32();
		
		sheets = new Vector<BitmapData>(num);
		
		f.seek(origOff, FileSeek.SeekBegin);
	}
	
	private function getSheet(f:FileInput, ID:Int):BitmapData
	{
		if (sheets[ID] != null) return sheets[ID];
		
		var origOff:Int = f.tell();
		f.seek(txtrOff, FileSeek.SeekBegin);
		
		var len:Int = f.readInt32();
		var num:Int = f.readInt32();
		
		for (i in 0...num)
		{
			var newOff:Int = f.readInt32();
			if (i != ID) continue;
			
			var tempOff:Int = f.tell() + 4;
			f.seek(newOff, FileSeek.SeekBegin);
			
			f.readInt32();
			var pngOff:Int = f.readInt32();
			/*var pngLen:Int;
			if (i < num - 1)
			{
				f.seek(4, FileSeek.SeekCur);
				pngLen = f.readInt32() - pngOff;
				f.seek( -4, FileSeek.SeekCur);
			}
			else
			{
				pngLen = len - pngOff;
			}*/
			
			f.seek(pngOff, FileSeek.SeekBegin);
			
			var dat:Data = new Reader(f).read();
			var header:Header = Tools.getHeader(dat);
			var bmp:BitmapData = new BitmapData(header.width, header.height, true, 0);
			var bytes:Bytes = Tools.extract32(dat);
			Tools.reverseBytes(bytes);
			bmp.setPixels(bmp.rect, ByteArray.fromBytes(bytes));
			sheets[i] = bmp;
			
			Sys.println('Loaded image $i...');
			
			f.bigEndian = false;
			f.seek(tempOff, FileSeek.SeekBegin);
			
			break;
		}
		
		f.seek(origOff, FileSeek.SeekBegin);
		
		return sheets[ID];
	}
	
	private function extractSprites(f:FileInput, off:Int)
	{
		var origOff:Int = f.tell();
		f.seek(off, FileSeek.SeekBegin);
		
		var len:Int = f.readInt32();
		var num:Int = f.readInt32();
		
		for (i in 0...num)
		{
			parseSprite(f, f.readInt32());
		}
		
		f.seek(origOff, FileSeek.SeekBegin);
	}
	
	private function parseSprite(f:FileInput, off:Int)
	{
		var origOff:Int = f.tell();
		f.seek(off, FileSeek.SeekBegin);
		
		var nameOff:Int = f.readInt32();
		f.seek(nameOff - 4, FileSeek.SeekBegin);
		var nLen:Int = f.readInt32();
		var name:String = f.readString(nLen);
		f.seek(off + 4, FileSeek.SeekBegin);
		
		//Extract only specific sprites
		/*if (name.indexOf('player_idle') == -1)
		{
			f.seek(origOff, FileSeek.SeekBegin);
			return;
		}*/
		
		Sys.println('Extracting $name');
		
		f.seek(0x34, FileSeek.SeekCur);
		var frameNum:Int = f.readInt32();
		
		var frameOff:Int = 0;
		var i:Int = 0;
		while (i < frameNum)
		{
			var temp:Int = f.readInt32();
			if (exclude && i > 0 && temp == frameOff) continue;
			frameOff = temp;
			
			extractFrame(f, frameOff, name, i);
			i++;
		}
		
		f.seek(origOff, FileSeek.SeekBegin);
	}
	
	private function extractFrame(f:FileInput, off:Int, name:String, num:Int)
	{
		var origOff:Int = f.tell();
		f.seek(off, FileSeek.SeekBegin);
		
		var x:Int = f.readInt16();
		var y:Int = f.readInt16();
		var w:Int = f.readInt16();
		var h:Int = f.readInt16();
		var rx:Int = f.readInt16();
		var ry:Int = f.readInt16();
		f.seek(4, FileSeek.SeekCur);
		var bw:Int = f.readInt16();
		var bh:Int = f.readInt16();
		var sheetID:Int = f.readInt16();
		
		var source:BitmapData = getSheet(f, sheetID);
		var frame:BitmapData = new BitmapData(bw, bh, true, 0);
		frame.copyPixels(source, new Rectangle(x, y, w, h), new Point(rx, ry), null, null, true);
		
		var outPath:String = Path.join([outDir, name, name + '_$num.png']);
		FileSystem.createDirectory(Path.directory(outPath));
		
		var dat:Data = Tools.build32ARGB(frame.width, frame.height, Bytes.ofData(frame.getPixels(frame.rect)));
		var o:FileOutput = File.write(outPath);
		new Writer(o).write(dat);
		o.close();
		
		f.seek(origOff, FileSeek.SeekBegin);
	}
}