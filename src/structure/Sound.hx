package structure;
import haxe.io.Bytes;
import haxe.io.Path;
import sys.io.FileInput;
import Util.*;

class Sound
{
	static public function read(f:FileInput, ?offset:Int):Sound
	{
		if (offset != null) jump(f, offset);
		
		var s:Sound = new Sound();
		
		s.name = getString(f, f.readInt32());
		s.flags = f.readInt32();
		s.type = getString(f, f.readInt32());
		s.file = getString(f, f.readInt32());
		s.unk = f.readInt32();
		s.volume = f.readFloat();
		s.pitch = f.readFloat();
		s.groupID = f.readInt32();
		s.audioID = f.readInt32();
		
		if (offset != null) jumpBack(f);
		
		return s;
	}
	
	private var name:String;
	private var flags:Int;
	private var type:String;
	private var file:String;
	private var unk:Int;
	private var volume:Float;
	private var pitch:Float;
	private var groupID:Int;
	private var audioID:Int;
	
	public function new() {}
	
	public function extract(f:FileInput, outDir:String)
	{
		if (flags & 1 == 0) return;
		
		var outPath:String = Path.join([outDir, file]);
		var audio:Bytes = Audio.get(f, audioID);
		
		Sys.println('Saving $outPath');
		saveBytes(outPath, audio);
	}
}