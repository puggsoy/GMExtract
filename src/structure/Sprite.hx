package structure;
import haxe.ds.Vector;
import haxe.io.Bytes;
import sys.io.FileInput;
import Util.*;

class Sprite
{
	static public function read(f:FileInput, ?offset:Int):Sprite
	{
		//TODO: Read a sprite object
		return null;
	}
	
	private var name:String;
	private var width:Int;
	private var height:Int;
	private var left:Int;
	private var right:Int;
	private var bottom:Int;
	private var top:Int;
	private var unk:Vector<Int>;
	private var bBoxMode:Int;
	private var sepMasks:Int;
	private var originX:Int;
	private var originY:Int;
	private var textureCount:Int;
	private var textureAddresses:Int;
	
	public function new()
	{}
}