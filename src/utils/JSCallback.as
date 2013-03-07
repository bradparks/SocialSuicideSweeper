package utils 
{
	import flash.external.ExternalInterface;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Renaud Bardet
	 */
	public class JSCallback 
	{
		
		public static function fb( _method : String, _args : *, _cb : Function ) : void
		{
			
			if ( ExternalInterface.available )
			{
				
				var cbName:String = generateFuncName() ;
				ExternalInterface.addCallback( cbName, _cb ) ;
				ExternalInterface.call(
					"function(x){" +
					"	FB.api(" + _method + ", x," +
					"	function(ret) {" +
					"		document.getElementById(" + ExternalInterface.objectID + ")." + cbName + "(ret)" +
					"	}" +
					"}",
					_args
				) ;
				
			}
			
		}
		
		private static function generateFuncName() : String
		{
			
			return "callback_" + getTimer() ;
			
		}
		
	}

}