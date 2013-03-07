package  
{
	import flash.geom.Rectangle;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Renaud Bardet
	 */
	
	public class Menu extends Sprite
	{
		
		private var upperLid : Sprite ;
		private var upperLidBG : Image ;
		private var logo : Image ;
		private var lowerLid : Sprite ;
		private var lowerLidBG : Image ;
		
		private var startBtn : Button ;
		
		public function Menu() 
		{
			
			upperLid = new Sprite() ;
			upperLidBG = new Image( Texture.fromColor( 10, 10, Resources.s.getColorAt( 1, 0 ) ) ) ;
			logo = new Image( Texture.fromTexture( Resources.s.tex, new Rectangle( 0, 48, 404, 48 ) ) ) ;
			upperLid.addChild( upperLidBG ) ;
			upperLid.addChild( logo ) ;
			addChild( upperLid ) ;
			lowerLid = new Sprite() ;
			lowerLidBG = new Image( Texture.fromColor( 10, 10, Resources.s.getColorAt( 2, 0 ) ) ) ;
			lowerLid.addChild( lowerLidBG ) ;
			addChild( lowerLid ) ;
			
			startBtn = new Button(
						Texture.fromTexture( Resources.s.tex, new Rectangle( 0, 96, 60, 24 ) ),
						"Start",
						Texture.fromTexture( Resources.s.tex, new Rectangle( 60, 96, 60, 24 ) )
					) ;
			startBtn.fontColor = 0xFFFFFF ;
			startBtn.fontName = "Verdana" ;
			
			startBtn.addEventListener( Event.TRIGGERED, onStart ) ;
			
			lowerLid.addChild( startBtn ) ;
			
			addEventListener( Event.ADDED_TO_STAGE, onAdded ) ;
			
		}
		
		private function onAdded( e : Event ) : void
		{
			
			removeEventListener( Event.ADDED_TO_STAGE, onAdded ) ;
			//addEventListener( ResizeEvent.RESIZE, onResize ) ;
			onResize( new ResizeEvent( ResizeEvent.RESIZE, stage.stageWidth, stage.stageHeight ) ) ;
			
		}
		
		private function onResize(e:ResizeEvent) : void
		{
			
			upperLid.removeChild( upperLidBG ) ;
			upperLidBG = new Image( Texture.fromColor( e.width, e.height / 2, Resources.s.getColorAt( 1, 0 ) ) ) ;
			upperLid.addChildAt( upperLidBG, 0 ) ;
			
			logo.y = (e.height / 2) - logo.height ;
			logo.x = (e.width - logo.width ) / 2 ;
			
			lowerLid.removeChild( lowerLidBG ) ;
			lowerLidBG = new Image( Texture.fromColor( e.width, e.height / 2, Resources.s.getColorAt( 2, 0 ) ) ) ;
			lowerLid.addChildAt( lowerLidBG, 0 ) ;
			
			startBtn.y = 20 ;
			startBtn.x = logo.x + logo.width - startBtn.width ;
			
			lowerLid.y = e.height / 2 ;
			
		}
		
		private function onStart(e:Event) : void
		{
			
			startBtn.removeEventListeners( Event.TRIGGERED ) ;
			
			var tweenStart : Tween = new Tween( startBtn, 0.5 ) ;
			tweenStart.animate( "alpha", .0 ) ;
			Starling.juggler.add( tweenStart ) ;
			
			var tween1 : Tween = new Tween( upperLid, 1.5, Transitions.EASE_OUT ) ;
			var tween2 : Tween = new Tween( lowerLid, 1.5, Transitions.EASE_OUT ) ;
			tween1.animate( "y", -3*upperLid.height / 4 ) ;
			tween2.animate( "y", lowerLid.y + 4*lowerLid.height / 5 ) ;
			tween1.onComplete = displayChoice ;
			Starling.juggler.add( tween1 ) ;
			Starling.juggler.add( tween2 ) ;
			
		}
		
		private function displayChoice() : void
		{
			
			//if( !hasPermissions )
			//	displayRules() ;
			
		}
		
	}

}