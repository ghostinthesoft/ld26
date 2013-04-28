package ;
import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;

/**
 * Input manager
 * @author 
 */
class Input
{
	static public var instance:Input=null;
	
	public var left:Bool;
	public var right:Bool;
	public var up:Bool;
	public var down:Bool;
	
	public function new() 
	{
		instance = this;
		
		left = false;
		right = false;
		up = false;
		down = false;
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, _keydown);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, _keyup);
	}
	
	public function _keydown(a_event:KeyboardEvent):Void
	{
		if (a_event.keyCode == Keyboard.UP)
			up = true;
		else if (a_event.keyCode == Keyboard.DOWN)
			down = true;
		else if (a_event.keyCode == Keyboard.RIGHT)
			right = true;
		else if (a_event.keyCode == Keyboard.LEFT)
			left = true;
	}
	
	public function _keyup(a_event:KeyboardEvent):Void
	{
		if (a_event.keyCode == Keyboard.UP)
			up = false;
		else if (a_event.keyCode == Keyboard.DOWN)
			down = false;
		else if (a_event.keyCode == Keyboard.RIGHT)
			right = false;
		else if (a_event.keyCode == Keyboard.LEFT)
			left = false;
	}
	
	
}