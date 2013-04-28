package ;
import flash.display.GraphicsPathCommand;
import flash.display.Sprite;
import flash.Lib;
import flash.Vector;

/**
 * Game & Title Background
 * @author Al1
 * 
 */
class Bg extends Sprite
{
	// number of lines
	inline static private var LINES_COUNT:Int = 5;
	
	// number of point in a screen
	// nombre impair nécessairement
	inline static private var LINES0_SIZE:Int = 6*Global.SCREEN_NUMBER;	
	inline static private var LINES1_SIZE:Int = 6*Global.SCREEN_NUMBER;	
	
	inline static private var LINES0_SPREAD:Int = 5;
	inline static private var LINES1_SPREAD:Int = 5;
	
	inline static private var LINES0_SPACE:Float = 1.0 / LINES0_SIZE;
	inline static private var LINES1_SPACE:Float = 1.0 / LINES1_SIZE;
	
	// lines properties
	static private var LINES_Y:Array<Float> = [-1.5,1,1.5,1.5,1.5];
	static private var LINES_D:Array<Float> = [100, 20, 10, 5, 3];
	static private var LINES_VY:Array<Float> = [1, 0, 0, 0, 0];
	static private var LINES_VD:Array<Float> = [1, 0.3, 0.3, 0.3, 0.3];
	static private var LINES_C:Array<Int> = [0x00FFFF, 0x436248, 0x337b3f, 0x3aa14c, 0x63d076, 0xaea059];

	
	private var m_lines_y:Array<Vector<Float>> = null;
	private var m_lines_d:Array<Vector<Float>> = null;
	private var m_commands:Array<Vector<Int>> = null;
	private var m_vertices:Array<Vector<Float>> = null;
	
	
	private var m_lines_count:Int =  LINES_COUNT;
	private var m_lines_size:Int = 0;
	private var m_lines_spread:Int = 0;
	private var m_lines_space:Float = 0;
	
	private var m_type:Int = 0;

	static public var instance:Bg = null;
	public function new() 
	{
		super();
		instance = this;
		
		x = Lib.current.stage.stageWidth >> 1;
		y = Lib.current.stage.stageHeight /3;
		
		m_lines_y = new Array<Vector<Float>>();
		m_lines_d = new Array<Vector<Float>>();
		m_commands = new Array<Vector<Int>>();
		m_vertices = new Array<Vector<Float>>();
	}
	
	// init background
	public function init(a_type:Int):Void
	{
		m_type = a_type;
		if (a_type == 1)
		{
			m_lines_size = LINES1_SIZE;
			m_lines_spread = LINES1_SPREAD;
			m_lines_space = LINES1_SPACE;
		}
		else
		{
			m_lines_size = LINES0_SIZE;
			m_lines_spread = LINES0_SPREAD;
			m_lines_space = LINES0_SPACE;
		}
		
		for (i in 0...m_lines_count+1)
		{
			m_commands[i] = new Vector<Int>();
			m_vertices[i] = new Vector<Float>();
		}
		
		for (i in 0...m_lines_count)
		{
			m_lines_y[i] = new Vector<Float>();
			m_lines_d[i] = new Vector<Float>();
			
			for (j in 0...((m_lines_size+1)*Global.SCREEN_NUMBER))
			{
				var linei:Int=i%m_lines_y.length;
				var liney:Float;
				var lined:Float;
				var linevy:Float;
				var linevd:Float;
				m_lines_y[i].push(Math.random()*LINES_VY[linei]);
				m_lines_d[i].push(Math.random()*LINES_VD[linei]);
			}
		}
		update(0, 0);
	}
	
	private function _fillBg(a_pos:Float, a_level:Int, a_buffer:Int, a_line:Int, a_reverse:Bool=false):Void
	{
		// Math.floor( -1.2)=-2
		// Math.ceil(-1.2))=-1
		var firstindex:Int = 0;
		if (a_reverse)
			firstindex = Math.round(a_pos * m_lines_size) + m_lines_spread;
		else
			firstindex = Math.round(a_pos * m_lines_size) - m_lines_spread;
			
		var animate:Bool = Title.instance != null && Title.instance.animate == 1;
		var normal:Bool = a_level > 0 && (m_type == 1 || !animate);
		for (j in 0...((m_lines_spread<<1)+1))
		{
			var linej:Int = (firstindex + (a_reverse?-j:j) + m_lines_size) % m_lines_size;
			// angles outside [-0.125, 0.125] are not visibles
			// here all angles are visibles
			var angle = Global.getAngle(linej * m_lines_space, a_pos);
			var viewd:Float = LINES_D[a_line];
			var viewy:Float = LINES_Y[a_line];
			if (normal)
			{
				viewy += m_lines_y[a_line][linej];
				viewd += m_lines_d[a_line][linej];
			}
			var viewz:Float = Global.getZ(angle, viewd);
			var viewx:Float = Global.getX(angle, viewd);
			
			var vertx:Float = Global.getScreenX(viewx, viewz);
			var verty:Float = Global.getScreenY(viewy, normal?viewz:viewd);
			
			if (j == 0 && !a_reverse)
				m_commands[a_buffer].push(GraphicsPathCommand.MOVE_TO);
			else
				m_commands[a_buffer].push(GraphicsPathCommand.LINE_TO);
			
			m_vertices[a_buffer].push(vertx);
			m_vertices[a_buffer].push(verty);
		}
	}
	
	public function update(a_elapsed:Int, a_pos:Float=0):Void
	{
		var level:Int = (m_type==0)?Global.BAR_LEVEL:Math.floor(Scenario.instance.perception);
		
		graphics.clear();
		
		var buffer:Int = 0;
		m_commands[buffer].length = 0;
		m_vertices[buffer].length = 0;
		
		_fillBg(a_pos, level, buffer, buffer);
		
		m_commands[buffer].push(GraphicsPathCommand.LINE_TO);
		m_vertices[buffer].push(m_vertices[buffer][m_vertices[buffer].length - 2]);
		m_vertices[buffer].push( -(Lib.current.stage.stageHeight/3) - 2 );
		
		m_commands[buffer].push(GraphicsPathCommand.LINE_TO);
		m_vertices[buffer].push(m_vertices[buffer][0]);
		m_vertices[buffer].push( -(Lib.current.stage.stageHeight/3) - 2 );
		
		graphics.beginFill(LINES_C[buffer]);
		graphics.drawPath(m_commands[buffer], m_vertices[buffer]);
		
		buffer++;

		
		for (i in 0...LINES_COUNT-1)
		{
			m_commands[buffer].length = 0;
			m_vertices[buffer].length = 0;
			
			_fillBg(a_pos, level, buffer, i, false);
			_fillBg(a_pos, level, buffer, i+1, true);

			graphics.beginFill(LINES_C[buffer]);
			graphics.drawPath(m_commands[buffer], m_vertices[buffer]);
			
			buffer++;
		}
		
		m_commands[buffer].length = 0;
		m_vertices[buffer].length = 0;
		
		_fillBg(a_pos, level, buffer, LINES_COUNT-1);
		
		m_commands[buffer].push(GraphicsPathCommand.LINE_TO);
		m_vertices[buffer].push(m_vertices[buffer][m_vertices[buffer].length - 2]);
		m_vertices[buffer].push( (Lib.current.stage.stageHeight*2/3) + 2 );
		
		m_commands[buffer].push(GraphicsPathCommand.LINE_TO);
		m_vertices[buffer].push(m_vertices[buffer][0]);
		m_vertices[buffer].push( (Lib.current.stage.stageHeight*2/3) + 2 );
		
		graphics.beginFill(LINES_C[buffer]);
		graphics.drawPath(m_commands[buffer], m_vertices[buffer]);
	}
	
}