package ;
import flash.display.Sprite;

/**
 * Scenario Builder
 * @author Al1
 */
class Scenario extends Sprite
{
	static inline private var MESSAGEY1:Float = 0.4;
	static inline private var MESSAGEY2:Float = 0.5;
	
	static inline private var MESSAGEWAIT:Float = 2000;
	
	static inline private var TIME_START:Int = 2000;
	
	static inline private var MALUS_FACTOR:Float = 0.0002*2;
	static inline private var BONUS_FACTOR:Float = 2.0*2;
	
	public var elements:List<Element>;
	
	public var perception:Int = 0;
	public var concentration:Float = 0;
	public var ready:Bool;
	
	public var disturbers:Int = 0;
	
	private var m_wait:Int = 0;
	private var m_time:Int = 0;
	private var m_first:Int = 0;
	
	static public var instance:Scenario;
	public function new() 
	{
		instance = this;
		super();
	}
	
	public function build():Void 
	{
		// reset time and tutorial for this scenario
		m_time = 0;
		m_wait = TIME_START;
		m_first = 0;
		
		disturbers = 0;
		
		// no input at beginning
		ready = false;

		// init perception/concentration
		perception = Global.BAR_LEVEL >> 1;
		concentration = Global.BAR_LEVEL >> 1;
		Hud.instance.setPerception(perception);
		Hud.instance.setConcentration(concentration);
		
		
		elements = new List<Element>();
		
		// init level
		
		// sky
		var maxCloud:Int = 10;
		for (i in 0...maxCloud)
		{
			var num:Int = 1 + Math.floor(/*3*/ 1* Math.random());
			var elt:Element = new Element("Cloud"+num);
			elt.posx = (i + Math.random() - 0.5) / maxCloud;
			elt.movex = 0.000005;
			elt.posy = 50 + 5 * (Math.random()-0.5);
			elt.posd = -100;
			elements.push(elt);
			addChild(elt);
		}
		
		// ground far
		/*var maxBushes1:Int = 10;
		for (i in 0...maxBushes1)
		{
			var elt:Element = new Element("Bushes1");
			elt.posx = (i + 2 * Math.random() - 1) / maxBushes1;
			elt.posy = -0.1 + 0.2 * Math.random();
			elements.push(elt);
			addChild(elt);
		}*/
		
		// trees
		var maxTree:Int = 4;
		for (i in 0...maxTree)
		{
			var elt:Element = new Element("Tree1");
			//elt.posx = (i + Math.random() ) / maxTree;
			//elt.posy = 0+0.1 * Math.random();
			elt.posx = i / maxTree;
			elt.posy = 1.5;
			elt.posd = 15+ 4*(Math.random()-0.5);
			elements.push(elt);
			addChild(elt);
		}
		
		// ground near
		/*var maxRock:Int = 10;
		for (i in 0...maxRock)
		{
			var elt:Element = new Element("Rock1");
			elt.posx = (i + 2 * Math.random() - 1) / maxRock;
			elt.posy = 0.1 + 0.2 * Math.random();
			elements.push(elt);
			addChild(elt);
		}*/
		
		// ground
		var maxGrass:Int = 10;
		for (i in 0...maxGrass)
		{
			var num:Int = 1 + Math.floor(Math.random() * 2);
			var elt:Element = new Element("Grass"+num);
			elt.posx = (i+Math.random())/maxGrass;
			elt.posy = /*0.25 + 0.25 * Math.random()*/1;
			elt.posd = 2.0 /*+ 1 * Math.random()*/;
			elements.push(elt);
			addChild(elt);
		}
		
		//debug
		m_first = 5;
		add();
	}
	
	public function add():Element 
	{
		var elt:Element = new Element("Bird1", true);
		elt.posx = Game.instance.pos + 0.25 + Math.random() * 0.5;
		if (elt.posx > 1)
			elt.posx -= 1;
		elt.posy = 2;
		elt.posd = 6;
		elements.push(elt);
		addChild(elt);
		
		disturbers++;
		
		return elt;
	}
	
	public function remove(a_id:Int):Void 
	{
		for (elt in elements)
		{
			if (elt.id == a_id)
			{
				if (elt.parent != null)
					elt.parent.removeChild(elt);
				elements.remove(elt);
				disturbers--;
				concentration += BONUS_FACTOR;
				Hud.instance.setConcentration(concentration);
				break;
			}
		}
	}
	
	public function update(a_elapsed:Int):Void 
	{
		m_time += a_elapsed;
			
		if (m_first > 2 && disturbers>0)
		{
			concentration -= MALUS_FACTOR * a_elapsed;
			Hud.instance.setConcentration(concentration);
		}

		var perceptionUp:Bool = false;
		var perceptionDown:Bool = false;
		if (concentration <= 0)
		{
			if (perception > 0)
			{
				concentration = Global.BAR_LEVEL;
				perception--;
				Hud.instance.setConcentration(concentration);					
				Hud.instance.setPerception(perception);
				perceptionDown = true;
			}
			else
				concentration = 0;
		}
		else if (concentration >= Global.BAR_LEVEL)
		{
			if (perception < Global.BAR_LEVEL)
			{
				concentration -= 1;
				perception++;
				Hud.instance.setConcentration(concentration);					
				Hud.instance.setPerception(perception);
				perceptionUp = true;
			}
			else
				concentration = 1;
		}
		
		// priority to concentration message
		if (perceptionUp)
		{
			Main.instance.cleanText();
			Main.instance.addText("You gain concentration", MESSAGEY1, 1, MESSAGEWAIT);
			Main.instance.addText("Your perception is improved", MESSAGEY2, 1, MESSAGEWAIT);
		}
		else if (perceptionDown)
		{
			Main.instance.cleanText();
			
			var wait:Int = MESSAGEWAIT;
			if (m_first == 2)
				wait = 5000;
			else if (m_first == 3)
				m_first = 4;
				
			Main.instance.addText("You lost concentration", MESSAGEY1, 1, wait);
			Main.instance.addText("Your perception is altered", MESSAGEY2, 1, wait);
		}
		else if (!Main.instance.textDisplayed())
		{
			// next step in scenario
			if (m_wait>0)
				m_wait -= a_elapsed;
				
			if (m_wait <= 0)
			{
				if (m_first == 0 || m_first == 1)
				{
					if (m_first == 1 && Input.instance.first)
					{
						m_first = 2;
					}
					else
					{
						if (disturbers == 0)
							add();
							
						Main.instance.addText("you can hear a bird, use arrow keys to find it", MESSAGEY1, 1, 5000);
						m_wait = 2000;
						m_first = 1;
					}
				}
				else if (m_first == 2)
				{
					// wait for input before doing next
					Main.instance.addText("the bird disturbs your concentration", MESSAGEY1, 1, 10000);
					Main.instance.addText("concentration has an influence on your perception", MESSAGEY2, 1, 10000);
					m_wait = 3000;
					m_first = 3;
				}
				else if (m_first == 3)
				{
				}
				else if (m_first == 4)
				{
					// wait for input before doing next
					Main.instance.addText("Click on the bird to recover your concentration", MESSAGEY1, 1, 10000);
					m_wait = 3000;
					
					if (disturbers==0)
						m_first = 5;
				}
				else
				{
					// create a new disturber
					var elt:Element = add();
					
					// wait for input before doing next
					Main.instance.addText(elt.getMessage(), MESSAGEY1, 1, MESSAGEWAIT);
					m_wait = 2000;
				}
			}
		}
	}
}