package ;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.Lib;


class LetterP extends MovieClip
{ public function new() { super(); } }
class LetterE extends MovieClip
{ public function new() { super(); } }
class LetterR extends MovieClip
{ public function new() { super(); } }
class LetterC extends MovieClip
{ public function new() { super(); } }
class LetterT extends MovieClip
{ public function new() { super(); } }
class LetterI extends MovieClip
{ public function new() { super(); } }
class LetterO extends MovieClip
{ public function new() { super(); } }
class LetterN extends MovieClip
{ public function new() { super(); } }


/**
 * Title
 * @author Al1
 */
class Title extends IState
{
	// speed of animation
	inline static private var LINES_ANIMATE_M0:Float = 500;
	inline static private var LINES_ANIMATE_R0:Float = 2000;
	inline static private var LINES_ANIMATE_M1:Float = 150;
	inline static private var LINES_ANIMATE_R1:Float = 150;
	
	// public
	public var animate:Int;

	// private
	private var m_letters:Array<MovieClip>;
	
	private var m_animate:Int;
	private var m_wait:Int;
	
	
	static public var instance:Title;
	public function new() 
	{
		super();
	}
	
	override public function init():Void
	{
		instance = this;
		
		animate = 2;
		m_wait = 0;

		
		// init bg
		Bg.instance.init(0);
		m_letters = new Array<MovieClip>();
		m_letters.push(new LetterP());
		m_letters.push(new LetterE());
		m_letters.push(new LetterR());
		m_letters.push(new LetterC());
		m_letters.push(new LetterE());
		m_letters.push(new LetterP());
		m_letters.push(new LetterT());
		m_letters.push(new LetterI());
		m_letters.push(new LetterO());
		m_letters.push(new LetterN());

		
		var letters:Sprite = new Sprite();
		addChild(letters);
		letters.x = Lib.current.stage.stageWidth >> 1;
		letters.y = Lib.current.stage.stageHeight /5;

		var index:Float= -m_letters.length*0.5;
		for (letter in m_letters)
		{
			letter.x = Math.floor( index * Lib.current.stage.stageWidth * 0.6/(m_letters.length-1));
			letters.addChild(letter);
			letter.gotoAndStop(1);
			index+=1;
		}
		
		Main.instance.addText("You lost your keys in a park", 0.5, 0);
		Main.instance.addText("Can you concentrate enough to find them ?", 0.67, 1);
		Main.instance.addText("Click on the screen when you're ready to start", 0.87, 2);
		
		Main.instance.addEventListener(MouseEvent.CLICK, Main.instance.gotoGame);
	}
	
	override public function uninit():Void
	{
		instance = null;
		Main.instance.removeEventListener(MouseEvent.CLICK, Main.instance.gotoGame);
	}
	
	override public function update(a_elapsed:Int):Void
	{
		m_wait -= Math.floor(a_elapsed);
		if (m_wait < 0)
		{
			if (animate !=0)
			{
				animate = 0;
				m_wait = Math.floor(LINES_ANIMATE_M0 + LINES_ANIMATE_R0 * Math.random());
				for (letter in m_letters)
				{
					if (letter.currentFrame!=1)
						letter.gotoAndStop(1);
				}
			}
			else
			{
				animate = 1;
				m_wait = Math.floor(LINES_ANIMATE_M1 + LINES_ANIMATE_R1 * Math.random());
				for (letter in m_letters)
				{
					if (Math.random() > 0.2 && letter.totalFrames>1)
						letter.gotoAndStop(2+Math.floor((letter.totalFrames-1)*Math.random()));
				}
			}
		}

		Bg.instance.update(a_elapsed, 0);
	}

	
}