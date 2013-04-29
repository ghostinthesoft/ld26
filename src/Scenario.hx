package ;
import flash.display.DisplayObject;
import flash.display.Sprite;

/**
 * Scenario Builder
 * @author Al1
 */
class Scenario extends Sprite
{
	static inline private var MESSAGEY1:Float = 0.4;
	static inline private var MESSAGEY2:Float = 0.5;
	
	static inline private var MESSAGEWAIT:Float = 1000;
	
	static inline private var TIME_START:Int = 2000;
	
	static inline private var MALUS_FACTOR:Float = 0.0005;
	static inline private var BONUS_OFFSET:Float = 5.0;
	static inline private var BONUS_FACTOR:Float = 3.0;
	
	public var elements:List<Element>;
	
	public var perception:Int = 0;
	public var concentration:Float = 0;
	public var ready:Bool;
	public var checked:Int;
	
	public var disturbers:Int = 0;
	
	private var m_spawn:Int = 0;
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
		m_spawn = 0;
		
		disturbers = 0;
		
		// no input at beginning
		ready = false;
		checked = 0;
		
		// init perception/concentration
		perception = 1;
		//perception = Global.PERCEPTION_LEVEL;
		concentration = Global.CONCENTRATION_LEVEL >> 1;
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
			elt.posy = -50 + 5 * (Math.random()-0.5);
			elt.posd = 100;
			elements.push(elt);
			_addElement(elt);
		}
		
		// bushes
		var maxBushes1:Int = 10;
		for (i in 0...maxBushes1)
		{
			var elt:Element = new Element("Bushes1");
			elt.posx = (i + Math.random() ) / maxBushes1;
			elt.posy = 1.5;
			elt.posd = 17+ 4*Math.random();
			elements.push(elt);
			_addElement(elt);
		}
		
		// trees
		var maxTree:Int = 10;
		for (i in 0...maxTree)
		{
			var elt:Element = new Element("Tree1");
			elt.posx = (i + Math.random() ) / maxTree;
			elt.posy = 1.5;
			elt.posd = 13+ 4*Math.random();
			elements.push(elt);
			_addElement(elt);
		}
		
		// bushes
		var maxBushes2:Int = 10;
		for (i in 0...maxBushes2)
		{
			var elt:Element = new Element("Bushes1");
			elt.posx = (i + Math.random() ) / maxBushes2;
			elt.posy = 1.5;
			elt.posd = 3+ 5*Math.random();
			elements.push(elt);
			_addElement(elt);
		}
		
		// grass, and hide the keys
		var maxGrass:Int = 15;
		var keysIndex:Int = Math.floor(Math.random() * maxGrass);
		for (i in 0...maxGrass)
		{
			var num:Int = 1 + Math.floor(Math.random() * 1);
			var elt:Element = new Element("Grass"+num, false, true);
			elt.posx = (i+Math.random())/maxGrass;
			elt.posy = 1;
			elt.posd = 2.0 + Math.random()*1;
			elt.keys = (i == keysIndex);
			elements.push(elt);
			_addElement(elt);
		}
		
		//debug
		/*m_first = 5;
		ready = true;
		add();*/
	}
	
	public function add():Element 
	{
		var elt:Element = new Element("Bird1", true, false);
		elt.posx = Game.instance.pos + 0.25 + Math.random() * 0.5;
		if (elt.posx > 1)
			elt.posx -= 1;
		elt.posy = 2;
		elt.posd = 6;
		elements.push(elt);
		
		disturbers++;
		
		_addElement(elt);
		return elt;
	}
	
	private function _addElement(a_element:Element):Void
	{
		var index:Int = 0;
		while (index != numChildren)
		{
			var child:Element = cast(getChildAt(index), Element);
			if (child.posd < a_element.posd)
			{
				addChildAt(a_element, index + 1);
				break;
			}
			index++;
		}
		if (a_element.parent == null)
			addChild(a_element);
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
				concentration += BONUS_FACTOR;//BONUS_OFFSET+(Global.PERCEPTION_LEVEL-perception)*BONUS_FACTOR;
				Hud.instance.setConcentration(concentration);
				break;
			}
		}
	}
	
	public function update(a_elapsed:Int):Void 
	{
		m_time += a_elapsed;
			
		// we stop everything when keys found
		if (checked !=1 && m_first > 2 && disturbers>0)
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
				concentration = Global.CONCENTRATION_LEVEL;
				perception--;
				Hud.instance.setConcentration(concentration);
				Hud.instance.setPerception(perception);
				perceptionDown = true;
			}
			else
				concentration = 0;
		}
		else if (concentration > Global.CONCENTRATION_LEVEL)
		{
			if (perception < Global.PERCEPTION_LEVEL)
			{
				concentration -= Global.CONCENTRATION_LEVEL;
				perception++;
				Hud.instance.setConcentration(concentration);					
				Hud.instance.setPerception(perception);
				perceptionUp = true;
			}
			else
				concentration = 1;
		}
		
		// priority to checked message
		if (checked!=0)
		{
			Main.instance.cleanText();
			if (checked == 1)
			{
				Main.instance.addText("congratulations !", MESSAGEY1, 1, 100000);
				Main.instance.addText("you found your keys !", MESSAGEY2, 1, 100000);
				
				// prevent interaction
				ready = false;
			}
			else
			{
				Main.instance.addText("Sorry, keys are not there", MESSAGEY1, 1, MESSAGEWAIT);
				checked = 0;
			}
		}
		// priority to concentration message
		else if (perceptionUp)
		{
			Main.instance.cleanText();
			
			if (perception == Global.PERCEPTION_LEVEL)
			{
				Main.instance.addText("your perception is sharped", MESSAGEY1, 1, MESSAGEWAIT);
				Main.instance.addText("look in the grass", MESSAGEY2, 1, MESSAGEWAIT);
			}
			else
			{
				Main.instance.addText("you gained concentration", MESSAGEY1, 1, MESSAGEWAIT);
				Main.instance.addText("your perception is improved", MESSAGEY2, 1, MESSAGEWAIT);
			}
		}
		else if (perceptionDown)
		{
			Main.instance.cleanText();
			
			var wait:Int = MESSAGEWAIT;
			if (m_first == 2)
				wait = 5000;
			else if (m_first == 3)
				m_first = 4;
				
			Main.instance.addText("you lost concentration", MESSAGEY1, 1, wait);
			Main.instance.addText("your perception is altered", MESSAGEY2, 1, wait);
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
					ready = true;
					
					// wait for input before doing next
					if (disturbers==0)
					{
						m_first = 5;
					}
					else
					{
						Main.instance.addText("click on the bird to recover your concentration", MESSAGEY1, 1, 10000);
						Main.instance.addText("when perception is minimalist, you can search your keys", MESSAGEY2, 1, 10000);
						m_wait = 3000;
					}
				}
			}
		}
		
		// spawn
		// we stop everything when keys found
		if (checked!=1 && m_first==5)
		{
			m_spawn -= a_elapsed;
			if (m_spawn<=0 && disturbers < 5)
			{
				// create a new disturber
				var elt:Element = add();
				m_spawn = 500+Math.floor((perception*0+1000)*Math.random());
				
				// wait for input before doing next
				//Main.instance.addText(elt.getMessage(), MESSAGEY1, 1, MESSAGEWAIT);
			}
		}
		
	}
}