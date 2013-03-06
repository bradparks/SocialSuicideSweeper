package  
{
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Renaud Bardet
	 */
	public class Resources 
	{
		
		[Embed(source="../assets/assets.png", mimeType="image/png")]
		private var Assets:Class ;
		
		public var tex : Texture ;
		
		public static var s : Resources = new Resources() ;
		
		public function Resources()
		{
			
			tex = Texture.fromBitmap( new Assets() ) ;
			
		}
		
	}

}