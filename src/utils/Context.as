package utils 
{
	/**
	 * A Simple context handling utility
	 * @author Renaud Bardet
	 */
	public class Context 
	{
		
		private var clearCB : Vector.<Function> ;
		
		public function Context() 
		{
			
			clearCB = new Vector.<Function>() ;
			
		}
		
		public function onClear( _f : Function ) : void
		{
			
			clearCB.push( _f ) ;
			
		}
		
		public function clear() : void
		{
			
			for each ( var cb : Function in clearCB )
			{
				
				cb() ;
				
			}
			
			clearCB.splice( 0, clearCB.length ) ;
			
		}
		
	}

}