package  
{
	import flash.display.Bitmap;
	import flash.display.InteractiveObject;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Renaud Bardet
	 */
	public class Resources 
	{
		
		[Embed(source="../assets/assets.png", mimeType="image/png")]
		private var Assets:Class ;
		
		public var src : Bitmap ;
		public var tex : Texture ;
		
		public static var s : Resources = new Resources() ;
		
		public function Resources()
		{
			
			src = new Assets() ;
			tex = Texture.fromBitmap( src ) ;
			
		}
		
		public function getColorAt( _x : int, _y : int ) : int
		{
			
			return src.bitmapData.getPixel32( _x, _y ) ;
			
		}
		
	}

}