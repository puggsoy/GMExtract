package;
import haxe.ds.GenericStack;
import sys.io.FileInput;
import sys.io.FileSeek;

class Util
{
	/**
	 * Stack of locations to jump back to.
	 */
	static private var jumpStack:GenericStack<Int> = new GenericStack<Int>();
	
	/**
	 * Jumps to an offset in a FileInput, storing the current position.
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
}