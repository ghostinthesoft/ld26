package ;
import flash.display.Sprite;
import flash.events.Event;

/**
 * Base class for main states
 * @author Al1
 * 
 */
class IState extends Sprite
{
	public function init():Void {}
	public function uninit():Void { }
	public function update(a_elapsed:Int):Void { }
}