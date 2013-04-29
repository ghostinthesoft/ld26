package ;
import flash.display.Sprite;
import flash.Lib;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.AntiAliasType;
import flash.text.TextFieldAutoSize;

/**
 * HUD
 * @author Al1
 */
class Hud extends Sprite
{
	inline static private var HUD_OFFSET:Int = 10;
	inline static private var BAR_HEIGHT:Int = 10;
	inline static private var BAR_WIDTH:Int = 100;
	
	private var pbar:Sprite;
	private var cbar:Sprite;
	
	private var plevel:Int;
	private var clevel:Int;
	
	static public var instance:Hud = null;
	public function new() 
	{
		instance = this;
		
		var perceptionTf:TextFormat = new TextFormat();
		perceptionTf.align = TextFormatAlign.LEFT;
		perceptionTf.size = 15;
		perceptionTf.color = Global.MAINCOLOR;
		perceptionTf.font = "mainfont";
			
		var perception:TextField = new TextField();
		perception.autoSize = TextFieldAutoSize.LEFT;
		perception.gridFitType = GridFitType.PIXEL;
		perception.antiAliasType = AntiAliasType.ADVANCED;
		perception.selectable = perception.mouseEnabled = false;
		perception.x = HUD_OFFSET;
		perception.y = HUD_OFFSET;
		
		perception.embedFonts = true;
		perception.text = "Perception";
		perception.setTextFormat(perceptionTf);
		perception.filters = [Global.textfilter];
		
		addChild(perception);
		
		var concentrationTf:TextFormat = new TextFormat();
		concentrationTf.align = TextFormatAlign.RIGHT;
		concentrationTf.size = 15;
		concentrationTf.color = Global.MAINCOLOR;
		concentrationTf.font = "mainfont";
			
		var concentration:TextField = new TextField();
		concentration.autoSize = TextFieldAutoSize.RIGHT;
		concentration.gridFitType = GridFitType.PIXEL;
		concentration.antiAliasType = AntiAliasType.ADVANCED;
		concentration.selectable = concentration.mouseEnabled = false;
		concentration.x = Lib.current.stage.stageWidth-HUD_OFFSET;
		concentration.y = HUD_OFFSET;
		
		concentration.embedFonts = true;
		concentration.text = "Concentration";
		concentration.setTextFormat(concentrationTf);
		concentration.filters = [Global.textfilter];
		
		addChild(concentration);
		
		var bary:Int = Math.floor(HUD_OFFSET * 2 + perception.height);
		this.graphics.beginFill(0x777777);
		this.graphics.drawRect(HUD_OFFSET, bary, BAR_WIDTH, BAR_HEIGHT);
		this.graphics.drawRect(Lib.current.stage.stageWidth-HUD_OFFSET-BAR_WIDTH, bary, BAR_WIDTH, BAR_HEIGHT);
		
		pbar = new Sprite();
		pbar.x = HUD_OFFSET;
		pbar.y = bary;
		pbar.graphics.beginFill(Global.MAINCOLOR);
		pbar.graphics.drawRect(0, 0, BAR_WIDTH, BAR_HEIGHT);
		addChild(pbar);
		
		cbar = new Sprite();
		cbar.x = Lib.current.stage.stageWidth-HUD_OFFSET-BAR_WIDTH;
		cbar.y = bary;
		cbar.graphics.beginFill(Global.MAINCOLOR);
		cbar.graphics.drawRect(0, 0, BAR_WIDTH, BAR_HEIGHT);
		addChild(cbar);
		
		super();
	}
	
	public function setPerception(a_value:Int):Void
	{
		var value:Float = a_value/Global.PERCEPTION_LEVEL;
		if (value < 0)
			value = 0;
		if (value > 1)
			value = 1;
		
		pbar.scaleX = value;
	}
	
	public function setConcentration(a_value:Float):Void
	{
		a_value /= Global.CONCENTRATION_LEVEL;
		if (a_value < 0)
			a_value = 0;
		if (a_value > 1)
			a_value = 1;
			
		cbar.scaleX = a_value;
	}
	
}