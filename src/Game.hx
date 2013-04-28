package ;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.GraphicsPathCommand;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.Vector;


/**
 * Main Game
 * @author Al1
 */
class Game extends IState 
{
	// constants
	static private var SPEED_INC:Float = 0.03;
	static private var SPEED_LIMIT:Float = 0.2;
	static private var TIMER_WAIT:Int = 2000;


	// public 
	public var pos:Float = 0;
	
	// private
	private var m_scenario:Scenario = null;
	private var m_speed:Float = 0;
	private var m_wait:Int = 0;
	
	static public var instance:Game;
	public function new() 
	{
		super();
	}
	
	override public function init():Void
	{
		instance = this;
		
		// init scenario first
		m_scenario = new Scenario();
		addChild(m_scenario);
		
		// init bg and add hud
		Bg.instance.init(1);
		Lib.current.stage.addChild(new Hud());
		
		
		x = stage.stageWidth >> 1;
		y = stage.stageHeight >> 1;
		
		m_scenario.build();
	}
	
	override public function uninit():Void
	{
	}
	
	override public function update(a_elapsed:Int):Void
	{
		// manage input
		if (Input.instance.right)
		{
			m_speed += SPEED_INC;
			if (m_speed > SPEED_LIMIT)
				m_speed = SPEED_LIMIT;
		}
		else if (Input.instance.left)
		{
			m_speed -= SPEED_INC;
			if (m_speed < -SPEED_LIMIT)
				m_speed = -SPEED_LIMIT;
		}
		else
		{
			if (m_speed > SPEED_INC)
				m_speed -= SPEED_INC;
			else if (m_speed < -SPEED_INC)
				m_speed += SPEED_INC;
			else
				m_speed = 0;
		}
		
		var newpos = pos+(m_speed * a_elapsed)/1000;
		var floorpos = Math.floor(newpos);
		pos = newpos - floorpos;
		
		Bg.instance.update(a_elapsed, pos);
		
		// update scenario
		m_scenario.update(a_elapsed);
		
		// update elements position
		for (elt in m_scenario.elements)
		{
			elt.update(a_elapsed, pos);
		}
	}
	
}