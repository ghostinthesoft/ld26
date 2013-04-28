package ;
import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;

/**
 * Input manager
 * @author Al1
 */
class Input
{
	public var first:Bool;
	public var left:Bool;
	public var right:Bool;
	
	static public var instance:Input=null;
	public function new() 
	{
		instance = this;
		
		first = false;
		left = false;
		right = false;
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, _keydown);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, _keyup);
	}
	
	public function _keydown(a_event:KeyboardEvent):Void
	{
		if (a_event.keyCode == Keyboard.RIGHT || a_event.keyCode == Keyboard.D)
		{
			first = true;
			right = true;
		}
		else if (a_event.keyCode == Keyboard.LEFT || a_event.keyCode == Keyboard.A || a_event.keyCode == Keyboard.Q)
		{
			first = true;
			left = true;
		}
	}
	
	public function _keyup(a_event:KeyboardEvent):Void
	{
		if (a_event.keyCode == Keyboard.RIGHT || a_event.keyCode == Keyboard.D)
			right = false;
		else if (a_event.keyCode == Keyboard.LEFT || a_event.keyCode == Keyboard.A || a_event.keyCode == Keyboard.Q)
			left = false;
	}
	
	
}