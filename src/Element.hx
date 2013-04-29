package ;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.Lib;
import haxe.Public;

class Cloud1 extends MovieClip
{ public function new() { super(); } }

class Cloud2 extends MovieClip
{ public function new() { super(); } }

class Cloud3 extends MovieClip
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
	static inline private var FADING_SPEED:Float = 0.005;
	
	static private var globalId:Int = 0;
	
	public var id:Int;
	
	public var posx:Float;
	public var movex:Float;
	public var posy:Float;
	public var posd:Float;
	public var keys:Bool;
	public var disturber:Bool;
	
	private var m_type:String;
	private var m_time:Int;

	private var m_place:Bool;
	
	private var m_wait:Int;
	private var m_max:Int;
	private var m_frame:Int;
	
	private var m_fading:Bool;

	//////////////////////////////////////////
	private var m_display:MovieClip;
	
	public function new(a_type:String, a_disturber:Bool=false, a_place:Bool=false) 
	{
		super();

		// no key in the element
		keys = false;
		
		// some elements are moving
		movex = 0;
		
		// disappear fading
		m_fading = false;
		
		// create display
		m_type = a_type;
		m_display = Type.createInstance(Type.resolveClass(m_type), []);
		var scale:Float;
		if (a_type.indexOf("Bushes") == 0)
			scale = Math.random() * 0.4 + 0.6;
		else
			scale = Math.random() * 0.1 + 0.9;
		m_display.scaleX = m_display.scaleY = scale;
		addChild(m_display);
		visible = false;
		
		// setup animation
		m_time = 0;
		if (a_type.indexOf("Bird") == 0)
		{
			m_frame = 100;
			m_wait = 3000;
		}
		else
		{
			m_frame = 100;
			m_wait = 200;
		}
		m_max = m_display.totalFrames * m_frame;
		m_display.stop();
		
		
		// element unique id
		id = globalId++;
		
		// element interaction
		m_place = a_place;
		disturber = a_disturber;
		var needListener:Bool = (disturber || m_place);
		mouseEnabled = mouseChildren = needListener;
		if (needListener)
			m_display.addEventListener(MouseEvent.CLICK, _onClick);
	}
	
	// get appearing message
	public function getMessage():String
	{
		if (m_type.indexOf("Bird") == 0)
		{
			return "you hear a bird";
		}
		return "what's this ?";
	}

	public function _onClick(a_event:MouseEvent)
	{
		if (Scenario.instance.ready)
		{
			if (disturber)
			{
				// click on a disturber
				m_display.removeEventListener(MouseEvent.CLICK, _onClick);
				m_fading = true;
			}
			else if (Scenario.instance.perception==Global.PERCEPTION_LEVEL)
			{
				// click on a place to find key
				Scenario.instance.checked = keys?1:2;
			}
		}
	}
	
	public function _updateAnim(a_elapsed:Int):Void
	{
		m_time += a_elapsed;
		
		var frame:Int = 1 + Scenario.instance.perception;
		if (frame == 1 && m_display.totalFrames>5)
		{
			if (m_time > m_max)
			{
				m_time = -Math.floor(Math.random() * m_wait);
			}
			
			if (m_time >= 0)
				frame = 6;
		}
		
		if (m_display.currentFrame != frame)
		{
			if (frame > m_display.totalFrames)
				frame = m_display.totalFrames;
			m_display.gotoAndStop(frame);
		}
	}
	
	public function update(a_elapsed:Int, a_origin:Float):Void
	{
		// scene is animated only when perception is the lowest
		if (Scenario.instance.perception==0 && movex > 0)
		{
			posx += movex * a_elapsed;
			while (posx > 1)
				posx -= 1;
		}
		var angle = Global.getAngle(posx, a_origin);
		
		// disappear fading
		if (m_fading)
		{
			var newalpha:Float = this.alpha - FADING_SPEED * a_elapsed;
			if (newalpha < 0.1)
			{
				Scenario.instance.remove(id);
			}
			else
			{
				this.alpha = newalpha;
				this.scaleX = this.scaleY = newalpha*newalpha;
			}
		}
		
		
		// angles outside [-0.125, 0.125] are not visibles
		// prevent viewz<=0
		visible = angle > -0.2 && angle < 0.2;
		
		if (visible)
		{
			var viewz:Float = Global.getZ(angle, posd);
			var viewx:Float = Global.getX(angle, posd);
			
			var scale:Float = (Scenario.instance.perception == Global.PERCEPTION_LEVEL)?1.0:( posd / viewz);
			scaleX = scaleY = scale;
			x = Global.getScreenX(viewx, viewz);
			y = Global.getScreenY(posy, Scenario.instance.perception==Global.PERCEPTION_LEVEL?posd:viewz);
			
			_updateAnim(a_elapsed);
		}
	}
	
	public function updateLevel(a_level:Int):Void
	{
	}
	
}