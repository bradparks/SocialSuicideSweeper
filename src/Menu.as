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
	import utils.Future;
	
	/**
	 * ...
	 * @author Renaud Bardet
	 */
	
	public class Menu extends Sprite
	{
		public var choice : Future ;
		
		private var choices:Array;
		
		public function Menu() 
		{
			
			super() ;
			
			choice = new Future() ;
			
			choices = [] ;
			
			for ( var i:int = 0 ; i < LevelDesign.LEVELS.length ; ++i )
			{ function f(ii:int):void {
				
				var level:* = LevelDesign.LEVELS[ii] ;
				var choiceClip : MenuChoice = new MenuChoice( level.label, '' + level.w + " x " + level.h, '' + level.mines + " mines" ) ;
				var spaceH:Number = 50 ;
				choiceClip.x = (spaceH + choiceClip.width) * ii ;
				addChild( choiceClip ) ;
				choices.push( choiceClip ) ;
				
				choiceClip.btn.addEventListener( Event.TRIGGERED, function(e:Event):void { onChoice( level ) ; } ) ;
				
			 } f(i) ; }
			
		}
		
		private function onChoice(l:*):void
		{
			
			for each ( var c:MenuChoice in choices )
			{
				c.btn.removeEventListeners( Event.TRIGGERED ) ;
			}
			
			choice.complete( l ) ;
			
		}
		
		override public function dispose() : void
		{
			
			super.dispose() ;
			
			for each ( var c : MenuChoice in choices )
			{
				
				c.resTF.dispose() ;
				c.minesTF.dispose() ;
				c.btn.dispose() ;
				c.dispose() ;
				
			}
			
		}
		
	}

}
import starling.text.TextField;
import starling.display.Button;
import starling.textures.Texture;

class MenuChoice extends starling.display.Sprite
{
	public var resTF:TextField;
	public var minesTF:TextField;
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
		
		resTF = new TextField( 100, 20, _res, "Verdana", 12, 0xFFFFFF ) ;
		resTF.y = 30 ;
		minesTF = new TextField( 100, 20, _mines, "Verdana", 12, 0xFFFFFF ) ;
		minesTF.y = 60 ;
		
		addChild( btn ) ;
		addChild( resTF ) ;
		addChild( minesTF ) ;
		
	}
	
}