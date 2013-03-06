package  
{
	import game.Sweeper;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	/**
	 * The main instructions class
	 * @author Renaud Bardet
	 */
	
	public class Core extends Sprite
	{
		
		public function Core() 
		{
			
			super() ;
			
			// create a new game view
			addChild( new Sweeper( 20, 15, 50 ) ) ;
			
		}
		
	}

}