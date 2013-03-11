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
		
		//private static var UNDEFINED_TEX : Texture 	= Texture.fromBitmapData( new BitmapData( 20, 20, true, 0xFF0000FF ) ) ;
		//private static var MINE_TEX : Texture 		= Texture.fromBitmapData( new BitmapData( 20, 20, true, 0xFFFF0000 ) ) ;
		//private static var EMPTY_TEX : Texture 		= Texture.fromBitmapData( new BitmapData( 20, 20, true, 0xFF00FF00 ) ) ;
		private static var UNDEFINED_TEX : Texture 	= Texture.fromTexture( Resources.s.tex, new Rectangle( 0, 24, 24, 24 ) ) ;
		private static var OVER_TEX : Texture 		= Texture.fromTexture( Resources.s.tex, new Rectangle( 24, 24, 24, 24 ) ) ;
		private static var MINE_TEX : Texture 		= Texture.fromTexture( Resources.s.tex, new Rectangle( 72, 24, 24, 24 ) ) ;
		private static var PEEK_TEX : Texture 		= Texture.fromTexture( Resources.s.tex, new Rectangle( 96, 24, 24, 24 ) ) ;
		private static var EMPTY_TEX : Texture 		= Texture.fromTexture( Resources.s.tex, new Rectangle( 48, 24, 24, 24 ) ) ;
		
		public var triggered : Signal ;
		
		public var cellType : Option ; //<CellType>
		private var revealed : Boolean ;
		public function isRevealed() : Boolean { return revealed ; }
		
		private var peekImg : Image ;
		private var tf:TextField;
		
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
			
		}
		
		public function reveal() : void
		{
			
			if ( !cellType.isDefined() )
				throw "unexpected error : this cell is not initialized" ;
			
			this.removeChildren() ;
			
			if ( cellType.getValue().equals( CellType.MINE ) )
				addChild( new Image(MINE_TEX) ) ;
			else
				addChild( new Image(EMPTY_TEX) ) ;
			
			revealed = true ;
			
		}
		
		public function hint( _i : int ) : void
		{
			
			tf = new TextField( 24, 24, '' + _i, "Verdana", 12, 0xFFFFFF ) ;
			addChild( tf ) ;
			
		}
		
		// displays the mine at the end of the game
		public function peek() : void
		{
			
			if ( cellType.getValue().equals( CellType.MINE ) )
			{
				this.removeChildren() ;
				peekImg = new Image(PEEK_TEX) ;
				addChild( peekImg ) ;
			}
			
		}
		
		private function onTouch( _e : TouchEvent ) : void
		{
			
			if ( _e.getTouch( this, TouchPhase.BEGAN ) != null )
				triggered.dispatch() ;
			
		}
		
		override public function dispose() : void
		{
			
			super.dispose() ;
			removeEventListeners( TouchEvent.TOUCH ) ;
			if ( peekImg != null )
				peekImg.dispose() ;
			if ( tf != null )
				tf.dispose() ;
			
		}
		
	}

}