package utils 
{
	/**
	 * ...
	 * @author Renaud Bardet
	 */
	public class Future 
	{
		
		private var val : Option ;
		
		private var callbacks : Vector.<Function> ;
		
		public function Future() 
		{
			
			val = Option.None ;
			
			callbacks = new Vector.<Function>() ;
			
		}
		
		public function isComplete() : Boolean
		{
			
			return val.isDefined() ;
			
		}
		
		public function onAvailable( _f : Function ) : void
		{
			
			if ( val.isDefined() )
			{
				
				if ( _f.length > 0 )
					_f( val.getValue() ) ;
				else
					_f() ;
				
			}
			else
			{
				
				callbacks.push( _f ) ;
				
			}
			
		}
		
		public function complete( _x : * = null ) : void
		{
			
			val = Option.Some( _x ) ;
			
			for each ( var cb : Function in callbacks )
			{
				
				if ( cb.length > 0 )
					cb( _x ) ;
				else
					cb() ;
				
			}
			
			callbacks.splice( 0, callbacks.length ) ;
			callbacks = null ;
			
		}
		
	}

}