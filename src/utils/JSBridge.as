package utils 
{
	import flash.external.ExternalInterface;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Renaud Bardet
	 */
	public class JSBridge 
	{
		
		public static function fb( _method : String, _cb : Function ) : void
		{
			
			if ( ExternalInterface.available )
			{
				
				var cbName:String = generateFuncName() ;
				ExternalInterface.addCallback( cbName, _cb ) ;
				trace( ExternalInterface.objectID ) ;
				ExternalInterface.call(
					"function(){" +
						"FB.api('" + _method + "'," +
							"function(ret) {" +
								"document.getElementById('" + ExternalInterface.objectID + "')." + cbName + "(ret) ;" +
							"})" +
					"}"
				) ;
				
			}
			
		}
		
		private static function generateFuncName() : String
		{
			
			return "callback_" + getTimer() ;
			
		}
		
	}

}