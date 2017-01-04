package;

import Util.*;
import easyconsole.Begin;
import easyconsole.End;
import haxe.ds.Vector;
import haxe.io.Path;
import openfl.display.BitmapData;
import structure.Sond;
import structure.Sprt;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileSeek;

class Main
{
	private var txtrOff:Int;
	private var sheets:Vector<BitmapData>;
	private var outDir:String;
	
	private var sprites:Bool = false;
	private var audio:Bool = false;
	
	static function main()
	{
		new Main();
	}
	
	public function new() 
	{
		var pName:String = Path.withoutExtension(Path.withoutDirectory(Sys.executablePath()));
		Begin.init();
		Begin.usage = 'Usage: $pName inFile outDir [-s|-a]]\n    inFile: The data.win file to extract from\n    outDir: The folder to save the extracted files to\n    -s: Only extract sprites\n    -a: Only extract audio';
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
		
		End.anyKeyExit(0, "Done");
	}
	
	private function checkOptions(options:Array<String>)
	{
		for (o in options)
		{
			switch(o)
			{
				case '-s':
					sprites = true;
				case '-a':
					audio = true;
			}
		}
		
		if (!sprites && !audio)
			sprites = audio = true;
	}
	
	private function extract(fPath:String)
	{
		var f:FileInput = File.read(fPath);
		f.bigEndian = false;
		f.seek(0, FileSeek.SeekEnd);
		var fLen:Int = f.tell();
		f.seek(0, FileSeek.SeekBegin);
		
		if (sprites)
		{
			Sys.println('Extracting sprites...');
			
			var sp:Sprt = Sprt.read(f);
			sp.extractAll(f, Path.join([outDir, 'sprites']));
		}
		
		if (audio)
		{
			Sys.println('Extracting audio...');
			
			var s:Sond = Sond.read(f);
			s.extractAll(f, Path.join([outDir, 'audio']));
		}
		
		f.close();
	}
}