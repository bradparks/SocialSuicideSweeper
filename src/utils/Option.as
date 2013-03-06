package utils 
{
	/**
	 * ...
	 * @author Renaud Bardet
	 */
	public class Option 
	{
		
		private var __isNone : Boolean ;
		
		private var val : * ;
		
		// use of this constructor is not recommended,
		// although the result is the same, use Some(x) instead
		public function Option( _x : * )
		{
			
			val = _x ;
			__isNone = false ;
			
		}
		
		public static function Some( _x : * ) : Option
		{
			
			return new Option( _x ) ;
			
		}
		
		public static function get None() : Option
		{
			
			var opt : Option = new Option(null) ;
			opt.__isNone = true ;
			return opt ;
			
		}
		
		public function isDefined() : Boolean
		{
			
			return !__isNone ;
			
		}
		
		public function getValue() : *
		{
			
			if ( __isNone )
				throw "get on None object" ;
			
			return val ;
			
		}
		
		public function equals( _o : Option ) : Boolean
		{
			
			if ( __isNone && _o.__isNone )
				return true ;
			if ( ( __isNone && !_o.__isNone ) || ( !__isNone && _o.__isNone ) )
				return false ;
			return val == _o.val ;
			
		}
		
		public function map( _f : Function ) : *
		{
			
			if ( __isNone )
				return this ;
			return Option.Some( _f( val ) ) ;
			
		}
		
		// _f should return an option
		public function mapOpt( _f : Function ) : *
		{
			
			if ( __isNone )
				return this ;
			return _f( val ) ;
			
		}
		
	}

}