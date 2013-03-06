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
		
		// for debug purposes only
		public static var s : Main ;
		
		private var starling : Starling ;
		
		public function Main():void 
		{
			
			s = this ;
			
			starling = new Starling( Core, this.stage ) ;
			starling.start() ;
			
		}
		
	}
	
}