package utils 
{
	import flash.automation.Configuration;
	/**
	 * ...
	 * @author Renaud Bardet
	 */
	public class Signal 
	{
		
		private var callbacks : Vector.<Function> ;
		
		public function Signal() 
		{
			
			callbacks = new Vector.<Function>() ;
			
		}
		
		public function add( _f : Function ) : void
		{
			
			if ( _f.length > 1 )
				throw "invalid function signature, callbacks bound to signals should be 0 or 1 arguments wide" ;
			
			callbacks.push( _f ) ;
			
		}
		
		public function remove( _f : Function ) : Boolean
		{
			
			for ( var i:int = 0 ; i < callbacks.length ; ++i )
			{
				
				if ( callbacks[i] == _f )
				{
					callbacks.splice( i, 1 ) ;
					return true ;
				}
				
			}
			
			return false ;
			
		}
		
		public function clear() : void
		{
			
			callbacks.splice( 0, callbacks.length ) ;
			
		}
		
		public function dispatch( _x : * = null ) : void
		{
			
			for each( var cb:Function in callbacks )
			{
				
				if ( cb.length == 0 )
					cb() ;
				else
					cb( _x ) ;
				
			}
			
		}
		
	}

}