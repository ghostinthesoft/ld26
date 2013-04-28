package ;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.Lib;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.AntiAliasType;
import flash.text.TextFieldAutoSize;
import haxe.FastList;

/**
 * Entry
 * @author Al1
 */

class Main extends Sprite
{
	static inline private var TEXT_FADE_TIME:Float = 0.0005;
	
	private var m_fade:Sprite;
	private var m_input:Input;
	private var m_state:IState;

	
	private var m_last:Int = 0;
	private var m_textformat:Array<TextFormat>;
	private var m_textfields:List<TextField>;
	private var m_textfade:Bool;
	private var m_textwait:Int;
	
	
	static public var instance:Main;
	static function main() 
	{
		new Main();
	}
	
	public function new() 
	{
		super();
		
		instance = this;
		
		var stage:Stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		stage.addChild(this);
		
		m_fade=new Sprite();
		m_fade.graphics.beginFill(0x0);
		m_fade.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		m_fade.alpha = 1;
		stage.addChild(m_fade);

		// text
		m_textfields = new List<TextField>();
		m_textformat = new Array<TextFormat>();
		for (i in 0...3)
		{
			var textformat:TextFormat = new TextFormat();
			textformat.align = TextFormatAlign.CENTER;
			textformat.size = 15+i*3;
			textformat.color = 0xffab49;
			textformat.font = "mainfont";
			m_textformat.push(textformat);
		}
		
		// inputs
		m_input = new Input();
		
		// bg
		this.addChild(new Bg());
		
		// entry point
		m_state = null;
		gotoTitle();
		
		stage.addEventListener(Event.ENTER_FRAME, _update);
	}
	
	public function addText(a_text:String, a_y:Float, a_type:Int, a_wait:Int=0) :Void
	{
		m_textwait = a_wait;
		var textfield:TextField = new TextField();
		textfield.autoSize = TextFieldAutoSize.CENTER;
		textfield.gridFitType = GridFitType.PIXEL;
		textfield.antiAliasType = AntiAliasType.ADVANCED;
		textfield.selectable = textfield.mouseEnabled = false;
		textfield.x = Lib.current.stage.stageWidth / 2;
		textfield.y = Lib.current.stage.stageHeight * a_y;
		textfield.embedFonts = true;
		//textfield.textColor = a_color;
		textfield.text = a_text;
		textfield.setTextFormat(m_textformat[a_type]);
		textfield.filters = [Global.textfilter];
		m_textfields.push(textfield);
		this.addChild(textfield);
	}
	
	public function textDisplayed():Bool
	{
		return m_textfields.length > 0;
	}
	
	public function cleanText() :Void
	{
		var num:Int = Lib.current.stage.numChildren;
		for (textfield in m_textfields)
		{
			if (textfield.parent != null)
				textfield.parent.removeChild(textfield);
			m_textfields.remove(textfield);
		}
	}
	
	public function gotoGame(a_event:Event=null) :Void
	{
		m_textfade = true;
		_goto("Game");
	}
	
	public function gotoTitle(a_event:Event=null) :Void
	{
		m_textfade = false;
		_goto("Title");
	}
	
	private function _goto(a_state:String) :Void
	{
		// clean old state
		if (m_state != null)
			m_state.uninit();
		cleanText();
		
		// reomve all graphic elements
		while (this.numChildren > 1)
			this.removeChildAt(1);
		
		// create new state
		m_state = (a_state == "Title")?new Title():new Game();
		this.addChild(m_state);
		m_state.init();
	}
	
	private function _update(a_event:Event) :Void
	{
		var current:Int = Lib.getTimer();
		var elapsed:Int = current - m_last;
		m_last = current;
		
		// starting fade
		if (m_fade!=null)
		{
			var alpha:Float = m_fade.alpha - elapsed * 0.0007;
			if (alpha < 0.01)
			{
				m_fade.parent.removeChild(m_fade);
				m_fade = null;
			}
			else
				m_fade.alpha = alpha;
		}
		else
		{
			// text fade
			if (m_textfade && m_textfields.length>0)
			{
				m_textwait -= elapsed;
				if (m_textwait < 0)
				{
					// fade
					for (textfield in m_textfields)
					{
						var alpha:Float = textfield.alpha - TEXT_FADE_TIME * elapsed;
						if (alpha < 0)
						{
							textfield.parent.removeChild(textfield);
							m_textfields.remove(textfield);
						}
						else
						{
							textfield.alpha = alpha;
						}
					}
				}
			}
			
			if (m_state != null)
			{
				m_state.update(elapsed);
			}
		}
	}
	
}