package game 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import utils.Option;
	import utils.Signal;
	
	/**
	 * ...
	 * @author Renaud Bardet
	 */
	public class Cell extends Sprite 
	{
		
		private static var UNDEFINED_TEX : Texture 	= Texture.fromBitmapData( new BitmapData( 20, 20, true, 0xFF0000FF ) ) ;
		private static var BOMB_TEX : Texture 		= Texture.fromBitmapData( new BitmapData( 20, 20, true, 0xFFFF0000 ) ) ;
		private static var EMPTY_TEX : Texture 		= Texture.fromBitmapData( new BitmapData( 20, 20, true, 0xFF00FF00 ) ) ;
		
		public var triggered : Signal ;
		
		private var cellType : Option ; //<CellType>
		
		public function Cell() 
		{
			
			super() ;
			
			cellType = Option.None ;
			
			this.addEventListener( TouchEvent.TOUCH, onTouch ) ;
			
			triggered = new Signal() ;
			
			var img:Image = new Image(UNDEFINED_TEX) ;
			addChild( img ) ;
			
		}
		
		public function init( _type : CellType ) : void
		{
			
			cellType = Option.Some( _type ) ;
			
			this.removeChildren() ;
			
			if ( cellType.getValue().equals( CellType.BOMB ) )
				addChild( new Image(BOMB_TEX) ) ;
			else
				addChild( new Image(EMPTY_TEX) ) ;
			
		}
		
		private function onTouch( _e : TouchEvent ) : void
		{
			
			if( _e.getTouch( this, TouchPhase.BEGAN ) != null )
				triggered.dispatch() ;
			
		}
		
	}

}