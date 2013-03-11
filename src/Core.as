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
	import starling.text.TextField;
	import starling.textures.Texture;
	import utils.Context;
	import utils.Future;
	import utils.JSBridge;
	
	/**
	 * Page flow and main container
	 * @author Renaud Bardet
	 */
	
	public class Core extends Sprite
	{
		
		private var upperLid : Sprite ;
		private var upperLidBG : Image ;
		private var logo : Image ;
		private var lowerLid : Sprite ;
		private var lowerLidBG : Image ;
		
		private var startBtn : Button ;
		private var menuBtn : Button ;
		
		private var container : Sprite ;
		private var context : Context ;
		
		public function Core() 
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
			
			menuBtn = new Button(
						Texture.fromTexture( Resources.s.tex, new Rectangle( 0, 96, 60, 24 ) ),
						"Menu",
						Texture.fromTexture( Resources.s.tex, new Rectangle( 60, 96, 60, 24 ) )
					) ;
			menuBtn.fontColor = 0xFFFFFF ;
			menuBtn.fontName = "Verdana" ;
			lowerLid.addChild( menuBtn ) ;
			menuBtn.visible = false ;
			
			container = new Sprite() ;
			addChild( container ) ;
			
			context = new Context() ;
			
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
				hasPermissions().onAvailable(
					function(b:Boolean):void {
						if( b )
							displayMenu() ;
						else
							displayRules() ;
					}
				) ;
			};
			Starling.juggler.add( tween1 ) ;
			Starling.juggler.add( tween2 ) ;
			
		}
		
		private function hasPermissions() : Future
		{
			
			var f : Future = new Future() ;
			JSBridge.fb( "me/permissions" ).onAvailable(
					function(_ret:*):void {
						f.complete( _ret.data[0].publish_actions == 1 ) ;
					}
				) ;
			return f ;
			
		}
		
		/**
		 * @param	_times	number of times this was called, for tracking reluctant users
		 */
		private function displayRules( _times : int = 0 ) : void
		{
			
			resetContainer() ;
			
			var disclaimerText : String = 
				"This game of minesweeper was designed so that every time you hit a bomb " +
				"a message is relayed on your wall.\n" +
				"\n" +
				"These messages are posts that comes from the following pages :\n" ;
			for each ( var page : String in LevelDesign.PAGES )
				disclaimerText += "\thttp://www.facebook.com/" + page + "\n" ;
			disclaimerText +=
				"\n" +
				"If you understand the above terms and wish to continue, wich is not a good idea " +
				"please login and accept the facebook permissions."
				;
			
			if ( _times > 0 )
			{
				disclaimerText =
					"Sorry, but the rules are the rules, no challenge, no game.\n" +
					"\n" +
					"Please login again and accept the permissions." ;
			}
			if ( _times == 7 )
			{
				disclaimerText =
					"Yay! Easter egg!\n" +
					"\n" +
					"Now accept the damn permissions!" ;
			}
			else if ( _times == 8 )
			{
				disclaimerText = "Ok you win, here, have a pony. (Reload the page to play)" ;
			}
			
			var disclaimerTF : TextField = new TextField( 500, 200, disclaimerText, "Verdana", 12, 0xFFFFFF ) ;
			disclaimerTF.hAlign = "left" ;
			disclaimerTF.x = (lowerLid.width - disclaimerTF.width) / 2 ;
			disclaimerTF.y = ((lowerLid.y - container.y) - disclaimerTF.height ) / 2 ;
			container.addChild( disclaimerTF ) ;
			
			if ( _times < 8 )
			{
				var loginBtn : Button = new Button(
							Texture.fromTexture( Resources.s.tex, new Rectangle( 0, 96, 60, 24 ) ),
							"Login",
							Texture.fromTexture( Resources.s.tex, new Rectangle( 60, 96, 60, 24 ) )
						) ;
				loginBtn.x = disclaimerTF.x + disclaimerTF.width - loginBtn.width ;
				loginBtn.y = disclaimerTF.y + disclaimerTF.height ;
				loginBtn.fontName = "Verdana" ;
				loginBtn.fontColor = 0xFFFFFF ;
				container.addChild( loginBtn ) ;
				
				loginBtn.addEventListener( Event.TRIGGERED,
					function(e:Event):void {
						loginBtn.removeEventListeners( Event.TRIGGERED ) ;
						JSBridge.fbLogin( ["publish_actions"] ).onAvailable( 
							function(ret:*):void
							{
								hasPermissions().onAvailable(
									function(_ok:Boolean):void
									{
										if( _ok )
											displayMenu() ;
										else
											displayRules( _times + 1 ) ;
									}
								) ;
							}
						) ;
					}
				) ;
			}
			else
			{
				disclaimerTF.vAlign = "top" ;
				disclaimerTF.hAlign = "center" ;
				disclaimerTF.y -= 20 ;
				
				var pony : Image = new Image( Texture.fromTexture( Resources.s.tex, new Rectangle( 0, 180, 256, 256 ) ) ) ;
				pony.x = (lowerLid.width - pony.width) / 2 ;
				pony.y = disclaimerTF.y + 20 ;
				container.addChild( pony ) ;
				
			}
			
		}
		
		private function displayMenu() : void
		{
			
			resetContainer() ;
			
			var menu:Menu = new Menu() ;
			menu.choice.onAvailable( startLevel ) ;
			menu.x = (lowerLid.width - menu.width) / 2 ;
			menu.y = ( (lowerLid.y - container.y) - menu.height ) / 2 ;
			container.addChild( menu ) ;
			
			menuBtn.visible = false ;
			menu.removeEventListeners( Event.TRIGGERED ) ;
			
		}
		
		private function startLevel( l:* ) : void
		{
			
			resetContainer() ;
			
			var sweeper:Sweeper = new Sweeper( l.w, l.h, l.mines ) ;
			sweeper.x = (lowerLid.width - sweeper.width) / 2 ;
			sweeper.y = ( (lowerLid.y - container.y) - sweeper.height ) / 2 ;
			container.addChild( sweeper ) ;
			
			menuBtn.visible = true ;
			menuBtn.x = lowerLid.width - menuBtn.width - 5 ;
			menuBtn.y = 5 ;
			menuBtn.addEventListener( Event.TRIGGERED, function(e:Event):void { displayMenu() ; } ) ;
			
			sweeper.end.onAvailable(
				function(_ok:Boolean):void {
					
					if ( !_ok )
					{
						
						var tf : TextField = new TextField( 500, 100, "loading your punishment...", "Verdana", 12, 0xFFFFFF ) ;
								tf.hAlign = "left" ;
								tf.vAlign = "top" ;
								tf.x = 25 ;
								lowerLid.addChild( tf ) ;
								
								var thumb : Image = new Image( Texture.fromTexture( Resources.s.tex, new Rectangle( 120, 96, 24, 24 ) ) ) ;
								lowerLid.addChild( thumb ) ;
								
								context.onClear(
									function():void {
										lowerLid.removeChild( tf ) ;
										lowerLid.removeChild( thumb ) ;
										thumb.texture.dispose() ;
									}
								) ;
						
						// post a nasty embarrassing post to the user's wall
						randomPost().onAvailable(
							function( _post : * ) : void
							{
								
								var content : * = { } ;
								var displayMessage : String = '' ;
								if ( _post.link != null )
								{
									content.link = _post.link ;
									content.name = _post.name ;
									content.description = _post.description ;
									displayMessage = _post.name + '\n' + _post.link ;
								}
								else
								{
									content.message = _post.message ;
									displayMessage = _post.message ;
								}
								content.actions = {
									name : "original message",
									link : "http://www.facebook.com/" + _post.id.split('_')[0] + "/posts/" + _post.id.split('_')[1]
								}
								
								JSBridge.fb( "me/feed", "post", content ) ;
								
								tf.text = displayMessage ;
								
							}
						) ;
						
					}
					
				} ) ;
			
		}
		
		private function randomPost() : Future
		{
			
			var ret : Future = new Future() ;
			
			var page : String = LevelDesign.PAGES[ Math.floor( Math.random() * LevelDesign.PAGES.length ) ] ;
			
			JSBridge.fb( page + "/feed" ).onAvailable(
				function( _feed : * ) : void
				{
					
					var post : * = _feed.data[ Math.floor( Math.random() * _feed.data.length ) ] ;
					ret.complete( post ) ;
					
				} ) ;
			
			return ret ;
			
		}
		
		private function resetContainer() : void
		{
			
			container.y = upperLid.y + upperLid.height ;
			container.removeChildren() ;
			
			context.clear() ;
			
		}
		
	}

}	