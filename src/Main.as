package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Renaud Bardet
	 */
	public class Main extends Sprite 
	{
		
		private var starling : Starling ;
		
		public function Main():void 
		{
			
			starling = new Starling( Core, this.stage ) ;
			
		}
		
	}
	
}