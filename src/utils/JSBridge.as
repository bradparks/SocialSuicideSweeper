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
		
		public static function fb( ... _args : Array ) : Future
		{
			
			var ret : Future = new Future() ;
			
			if ( ExternalInterface.available )
			{
				
				var cbName:String = generateFuncName() ;
				ExternalInterface.addCallback( cbName, ret.complete ) ;
				
				var argChain : Array = [] ;
				for ( var i:int = 0 ; i < _args.length ; ++i )
					argChain.push( "x" + i ) ;
				
				var jsFunc : String = 
					"function(" + argChain.join(',' ) + "){" +
						"FB.api(" + argChain.join( ',' ) + ',' +
							"function(ret) {" +
								"document.getElementById('" + ExternalInterface.objectID + "')." + cbName + "(ret) ;" +
							"})" +
					"}" ;
				
				_args.unshift( jsFunc ) ;
				
				ExternalInterface.call.apply( null, _args ) ;
				
			}
			
			return ret ;
			
		}
		
		public static function fbLogin( _perms : Array ) : Future
		{
			
			var ret : Future = new Future() ;
			
			if ( ExternalInterface.available )
			{
				
				var cbName:String = generateFuncName() ;
				ExternalInterface.addCallback( cbName, ret.complete ) ;
				ExternalInterface.call(
					"function(){" +
						"FB.login(" +
							"function(ret) {" +
								"document.getElementById('" + ExternalInterface.objectID + "')." + cbName + "(ret) ;" +
							"}" +
							", {scope:'" + _perms.join(',') + "'}" +
							")" +
					"}"
				) ;
				
			}
			
			return ret ;
			
		}
		
		private static function generateFuncName() : String
		{
			
			return "callback_" + getTimer() ;
			
		}
		
	}

}