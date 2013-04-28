package ;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.Lib;
import haxe.Public;

class Cloud1 extends MovieClip
{ public function new() { super(); } }

class Bushes1 extends MovieClip
{ public function new() { super(); } }

class Tree1 extends MovieClip
{ public function new() { super(); } }

class Rock1 extends MovieClip
{ public function new() { super(); } }

class Grass1 extends MovieClip
{ public function new() { super(); } }

class Grass2 extends MovieClip
{ public function new() { super(); } }

class Bird1 extends MovieClip
{ public function new() { super(); } }




/**
 * Element
 * @author Al1
 */
class Element extends Sprite
{
	static private var globalId:Int = 0;
	
	public var id:Int;
	
	public var posx:Float;
	public var posy:Float;
	
	
	private var m_type:String;
	private var m_time:Int;
	
	private var m_wait:Int;
	private var m_max:Int;
	private var m_frame:Int;

	//////////////////////////////////////////
	private var m_display:MovieClip;
	
	public function new(a_type:String) 
	{
		super();
		m_type = a_type;
		m_display = Type.createInstance(Type.resolveClass(m_type), []);
		addChild(m_display);
		visible = false;
		
		m_time = 0;
		if (a_type.indexOf("Bird") == 0)
		{
			m_frame = 100;
			m_wait = 3000;
		}
		else
			m_wait = 0;
			
		m_max = m_display.totalFrames * m_frame;
		m_display.stop();
		
		
		id = globalId++;
	}

	public function _updateAnim(a_elapsed:Int):Void
	{
		m_time += a_elapsed;
		if (m_time > m_max)
			m_time = -Math.floor(Math.random() * m_wait);
			
		var frame:Int = m_time;
		if (frame < 0)
			frame = 0;
		
		m_display.gotoAndStop(frame);
	}
	
	public function update(a_elapsed:Int, a_origin:Float):Void
	{
		var diffx = Global.getX(posx, a_origin);
		var z:Float = Global.getZ(diffx);
		
		diffx *= Game.SCREEN_NUMBER;
		visible = z > 0 && diffx > -0.8 && diffx < 0.8;
		
		if (visible)
		{
			var scale:Float = 1 / z;
			scaleX = scaleY = scale;
			x = diffx * Lib.current.stage.stageWidth;
			y = posy * Lib.current.stage.stageHeight / z;
			
			_updateAnim(a_elapsed);
		}
		
		//trace("elt " + frame + " x=" + x+ " y=" + y+ " diff=" + diff);
	}
	
	public function updateLevel(a_level:Int):Void
	{
	}
	
}