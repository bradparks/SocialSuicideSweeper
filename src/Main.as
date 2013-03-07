package 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
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
			
			stage.align = StageAlign.TOP_LEFT ;
			stage.scaleMode = StageScaleMode.NO_SCALE ;
			
			s = this ;
			
			Starling.handleLostContext = true ;
			
			starling = new Starling( Core, this.stage ) ;
			starling.start() ;
			
		}
		
	}
	
}