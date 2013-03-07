package  
{
	import flash.geom.Rectangle;
	import game.Sweeper;
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
		
		// ugly harcoded level-design
		private static const LEVELS : Array = [
			{ label : "Easy", w : 10, h : 10, mines : 10 },
			{ label : "Medium", w : 20, h : 15, mines : 50 },
			{ label : "Hard", w : 30, h : 15, mines : 100 },
		] ;
		
		private var upperLid : Sprite ;
		private var upperLidBG : Image ;
		private var logo : Image ;
		private var lowerLid : Sprite ;
		private var lowerLidBG : Image ;
		
		private var startBtn : Button ;
		
		private var container : Sprite ;
		
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
			
			container = new Sprite() ;
			addChild( container ) ;
			
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
			tween1.onComplete = function():void {
				//if( !hasPermissions )
				//	displayRules() ;
				// else
				displayChoice() ;
			};
			Starling.juggler.add( tween1 ) ;
			Starling.juggler.add( tween2 ) ;
			
		}
		
		private function displayChoice() : void
		{
			
			// reset main container
			container.y = upperLid.y + upperLid.height ;
			container.removeChildren() ;
			
			var choices : Array = [] ;
			
			function onChoice(l:*):void
			{
				
				for each ( var c:MenuChoice in choices )
				{
					c.btn.removeEventListeners( Event.TRIGGERED ) ;
				}
				
				startLevel(l) ;
				
			}
			
			for ( var i:int = 0 ; i < LEVELS.length ; ++i )
			{ function f(ii:int):void {
				
				var level:* = LEVELS[ii] ;
				var choiceClip : MenuChoice = new MenuChoice( level.label, '' + level.w + " x " + level.h, '' + level.mines + " mines" ) ;
				choiceClip.y = ( (lowerLid.y - container.y) - choiceClip.height ) / 2 ;
				var spaceH:Number = (lowerLid.width - (LEVELS.length * choiceClip.width)) / 6 ;
				choiceClip.x = spaceH * (2 + ii) + choiceClip.width * ii ;
				container.addChild( choiceClip ) ;
				choices.push( choiceClip ) ;
				
				choiceClip.btn.addEventListener( Event.TRIGGERED, function(e:Event):void { onChoice( level ) ; } ) ;
				
			 } f(i) ; }
			
		}
		
		private function startLevel( l:* ) : void
		{
			
			// reset main container
			container.y = upperLid.y + upperLid.height ;
			container.removeChildren() ;
			
			var sweeper:Sweeper = new Sweeper( l.w, l.h, l.mines ) ;
			sweeper.y = ( (lowerLid.y - container.y) - sweeper.height ) / 2 ;
			container.addChild( sweeper ) ;
			
			sweeper.end.onAvailable(
				function(_ok:Boolean):void {
					
					displayChoice() ;
					
				} ) ;
			
		}
		
	}

}
import starling.text.TextField;
import starling.display.Button;
import starling.textures.Texture;

class MenuChoice extends starling.display.Sprite
{
	
	public var btn : Button ;
	
	public function MenuChoice( _label : String, _res : String, _mines : String )
	{
		
		super() ;
		
		btn = new Button(
			Texture.fromTexture( Resources.s.tex, new flash.geom.Rectangle( 0, 96, 60, 24 ) ),
			_label,
			Texture.fromTexture( Resources.s.tex, new flash.geom.Rectangle( 60, 96, 60, 24 ) )
		) ;
		btn.fontName = "Verdana" ;
		btn.fontColor = 0xFFFFFF ;
		btn.x = 20
		
		var resTF:TextField = new TextField( 100, 20, _res, "Verdana", 12, 0xFFFFFF ) ;
		resTF.y = 30 ;
		var minesTF:TextField = new TextField( 100, 20, _mines, "Verdana", 12, 0xFFFFFF ) ;
		minesTF.y = 60 ;
		
		addChild( btn ) ;
		addChild( resTF ) ;
		addChild( minesTF ) ;
		
	}
	
}