package;

import Util.*;
import easyconsole.Begin;
import easyconsole.End;
import haxe.io.Path;
import structure.Sond;
import structure.Sprt;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileSeek;
import systools.Dialogs;

class Main
{
	private var inFile:String;
	private var outDir:String;
	
	private var sprites:Bool = false;
	private var audio:Bool = false;
	
	static function main()
	{
		new Main();
	}
	
	public function new() 
	{
		Sys.println('GMExtract v1.1 - by puggsoy\n');
		
		var pName:String = Path.withoutExtension(Path.withoutDirectory(Sys.executablePath()));
		Begin.init();
		Begin.usage = 'Usage: $pName inFile outDir [-s|-a]]\n    inFile: The data.win file to extract from\n    outDir: The folder to save the extracted files to\n    -s: Only extract sprites\n    -a: Only extract audio\n';
		Begin.functions = [useUI, null, checkArgs];
		Begin.parseArgs();
	}
	
	private function checkArgs()
	{
		inFile = Begin.args[0];
		
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
		extract();
		
		End.anyKeyExit(0, "Done");
	}
	
	private function useUI()
	{
		Sys.println(Begin.usage);
		
		var filters:FILEFILTERS =
		{
			count: 1,
			descriptions: ['.win files'],
			extensions: ['*.win']
		};
		
		inFile = Dialogs.openFile('Select data.win file', 'Select data.win file', filters)[0];
		
		if (inFile == null)
		{
			End.terminate(1, 'No input file chosen!');
		}
		
		outDir = Dialogs.folder('Select output directory...', 'Select output directory...');
		
		if (outDir == null)
		{
			End.terminate(1, 'No output directory chosen!');
		}
		
		sprites = audio = true;
		
		extract();
		
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
	
	private function extract()
	{
		var f:FileInput = File.read(inFile);
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