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

class Bg extends MovieClip
{ public function new() { super(); } }


/**
 * Main Game
 * @author Al1
 */
class Game extends IState 
{
	static public var SCREEN_NUMBER:Int = 4;
	
	static private var SPEED_INC:Float = 0.03;
	static private var SPEED_LIMIT:Float = 0.2;
	
	static private var TIMER_WAIT:Int = 2000;
	
	// number of lines
	static private var LINES_COUNT:Int = 5;
	
	// number of point in a screen
	static private var LINES_SIZE:Int = 5;	// nombre impair nécessairement
	
	// lines properties
	static private var LINES_Y:Array<Float> = [-0.3,-0.05,0.1,0.1,0.1];
	static private var LINES_Z:Array<Float> = [5,3,2,1.0,0.4];
	static private var LINES_C:Array<Int> = [0x436248, 0x337b3f, 0x3aa14c, 0x63d076, 0xaea059];

	static private var LINES_SPACEX:Float = 1.0 / ((LINES_SIZE + 1) * SCREEN_NUMBER);
	
	private var m_commands:Array<Vector<Int>> = null;
	private var m_vertices:Array<Vector<Float>> = null;
	

	private var m_bg:Sprite = null;
	private var m_lines:Array<Vector<Float>> = null;
	
	private var m_scenario:Scenario = null;
	private var m_level:Int = 0;
	
	private var m_pos:Float = 0;
	private var m_speed:Float = 0;

	private var m_wait:Int = 0;
	
	public function new() 
	{
		super();
	}
	
	override public function init():Void
	{
		m_scenario = new Scenario();
		
		m_bg = new Sprite();
		addChild(m_bg);
		
		m_lines = new Array<Vector<Float>>();
		m_commands = new Array<Vector<Int>>();
		m_vertices = new Array<Vector<Float>>();
		
		for (i in 0...LINES_COUNT)
		{
			m_lines[i] = new Vector<Float>();
			m_commands[i] = new Vector<Int>();
			m_vertices[i] = new Vector<Float>();
			
			for (j in 0...((LINES_SIZE+1)*SCREEN_NUMBER))
			{
				var range:Float;
				if (i == 1)
					range = 0.1;
				else if (i == 4)
					range = 0.03;
				else
					range = 0.04;
				m_lines[i].push(LINES_Y[i%LINES_Y.length]+Math.random()*range);
			}
		}
		
		addChild(m_scenario);
		
		x = stage.stageWidth / 2;
		y = stage.stageHeight / 2;

		
		_start();
	}
	
	override public function uninit():Void
	{
	}
	
	/**
	 * Start a new level
	 * 
	 */
	public function _start():Void
	{
		m_scenario.build(0);
		
		// add a disturber
		m_scenario.add();
	}
	
	private function _fillBg(a_buffer:Int, a_line:Int, a_reverse:Bool=false):Void
	{
		var firstindex:Int = 0;
		if (a_reverse)
			firstindex = Math.ceil(m_pos * SCREEN_NUMBER * (LINES_SIZE + 1)+ ((LINES_SIZE + 1) >> 1));
		else
			firstindex = Math.floor(m_pos * SCREEN_NUMBER * (LINES_SIZE + 1)- ((LINES_SIZE + 1) >> 1));
			
		for (j in 0...LINES_SIZE+3)
		{
			var linej:Int = (firstindex + (a_reverse?-j:j) + (LINES_SIZE+1)* SCREEN_NUMBER) % ((LINES_SIZE+1)* SCREEN_NUMBER);
			if (m_level == 0)
			{
				// convert abs pos into screen pos
				var screenx = Global.getX(linej * LINES_SPACEX, m_pos);
				
				var z = Global.getZ(screenx)*LINES_Z[a_line];
				
				var vertx:Float = screenx * SCREEN_NUMBER * Lib.current.stage.stageWidth;
				var verty:Float = m_lines[a_line][linej] * Lib.current.stage.stageHeight / z;
				
				if (j == 0 && !a_reverse)
				{
					m_commands[a_buffer].push(GraphicsPathCommand.MOVE_TO);
				}
				else
					m_commands[a_buffer].push(GraphicsPathCommand.LINE_TO);
				
				m_vertices[a_buffer].push(vertx);
				m_vertices[a_buffer].push(verty);
			}
		}
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
		
		var pos = m_pos+(m_speed * a_elapsed)/1000;
		var floorpos = Math.floor(pos);
		m_pos = pos - floorpos;
		
		// draw bg
		// Math.floor( -1.2)=-2
		// Math.ceil(-1.2))=-1
		
		var lastx:Float = -99;
		
		// space between vertices 
		graphics.clear();
		for (i in 0...LINES_COUNT-1)
		{
			m_commands[i].length = 0;
			m_vertices[i].length = 0;
			
			_fillBg(i, i);
			_fillBg(i, i+1, true);

			graphics.beginFill(LINES_C[i]);
			graphics.drawPath(m_commands[i], m_vertices[i]);
		}
		
		var i = LINES_COUNT-1;
		m_commands[i].length = 0;
		m_vertices[i].length = 0;
		
		_fillBg(i, i);
		
		m_commands[i].push(GraphicsPathCommand.LINE_TO);
		m_vertices[i].push(m_vertices[i][m_vertices[i].length - 2]);
		m_vertices[i].push( (Lib.current.stage.stageHeight >> 1) + 2 );
		
		m_commands[i].push(GraphicsPathCommand.LINE_TO);
		m_vertices[i].push(m_vertices[i][0]);
		m_vertices[i].push( (Lib.current.stage.stageHeight >> 1) + 2 );
		
		graphics.beginFill(LINES_C[i]);
		graphics.drawPath(m_commands[i], m_vertices[i]);

		

		// update elements display
		/*if (m_scenario.elements.length != 10)
		{
			m_scenario.add();
		}*/
		
		// update elements position
		for (elt in m_scenario.elements)
		{
			elt.update(a_elapsed, m_pos);
		}
	}
	
}