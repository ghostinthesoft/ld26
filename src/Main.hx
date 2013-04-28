package ;

import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;

/**
 * Entry
 * @author Al1
 */

class Main 
{
	// instances
	static public var input:Input;
	static public var state:IState;

	
	static private var m_last:Int = 0;
	
	
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;

		
		// inputs
		input = new Input();
		
		// entry point
		state = new Game();
		stage.addChild(state);
		state.init();
		
		stage.addEventListener(Event.ENTER_FRAME, _update);
	}
	
	static private function _update(a_event:Event) :Void
	{
		var current:Int = Lib.getTimer();
		var elapsed:Int = current - m_last;
		m_last = current;
		
		if (state != null)
		{
			state.update(elapsed);
		}
	}
	
}