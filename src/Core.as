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
			
			// display the menu
			addChild( new Menu() ) ;
			
			// create a new game view
			//addChild( new Sweeper( 10, 10, 10 ) ) ;
			
		}
		
	}

}