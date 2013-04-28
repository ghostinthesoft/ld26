package ;
import flash.display.Sprite;

/**
 * Scenario Builder
 * @author Al1
 */
class Scenario extends Sprite
{
	public var elements:Array<Element>;
	
	public var disturbers:Int = 0;
	
	public function new() 
	{
		super();
	}
	
	public function build(a_level:Int):Void 
	{
		elements = new Array<Element>();
		
		// init level
		
		// sky
		var maxCloud:Int = 10;
		for (i in 0...maxCloud)
		{
			var elt:Element = new Element("Cloud1");
			elt.posx = (i+2*Math.random()-1)/maxCloud;
			elt.posy = -0.5+0.25 * Math.random();
			elements.push(elt);
			addChild(elt);
		}
		
		// ground far
		var maxBushes1:Int = 10;
		for (i in 0...maxBushes1)
		{
			var elt:Element = new Element("Bushes1");
			elt.posx = (i + 2 * Math.random() - 1) / maxBushes1;
			elt.posy = -0.1 + 0.2 * Math.random();
			elements.push(elt);
			addChild(elt);
		}
		
		// trees
		var maxTree:Int = 10;
		for (i in 0...maxTree)
		{
			var elt:Element = new Element("Tree1");
			elt.posx = (i + Math.random() ) / maxTree;
			elt.posy = 0+0.1 * Math.random();
			elements.push(elt);
			addChild(elt);
		}
		
		// ground near
		var maxRock:Int = 10;
		for (i in 0...maxRock)
		{
			var elt:Element = new Element("Rock1");
			elt.posx = (i + 2 * Math.random() - 1) / maxRock;
			elt.posy = 0.1 + 0.2 * Math.random();
			elements.push(elt);
			addChild(elt);
		}
		
		// ground
		var maxGrass:Int = 10;
		for (i in 0...maxGrass)
		{
			var num:Int = 1 + Math.floor(Math.random() * 2);
			var elt:Element = new Element("Grass"+num);
			elt.posx = (i+Math.random())/maxGrass;
			elt.posy = 0.25+0.25 * Math.random();
			elements.push(elt);
			addChild(elt);
		}
		//add();
		
		
	}
	
	public function add():Void 
	{
		var elt:Element = new Element("Bird1");
		elt.posx = Math.random();
		elt.posy = 0.25;
		elements.push(elt);
		addChild(elt);
	}
	
	public function remove(a_id:Int):Void 
	{
	}
	
}