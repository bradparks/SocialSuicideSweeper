package game 
{
	import starling.events.Event;
	import flash.utils.getTimer;
	import starling.display.Sprite;
	import starling.text.TextField;
	import utils.Future;
	
	/**
	 * ...
	 * @author Renaud Bardet
	 */
	public class Sweeper extends Sprite 
	{
		
		private var resW : int ;
		private var resH : int ;
		private var numMines : int ;
		
		private var cells : Vector.<Cell> ;
		private var uncovered : int ; // count the number of uncovered cells as they reveal, cheaper than checking the whole grid each time
		
		private var initialized : Boolean = false ;
		
		private var startTime : Number ;
		
		private var gridLayer : Sprite ;
		
		public var end : Future ;
		
		public function Sweeper( _resW : int, _resH : int, _numMines : int ) 
		{
			
			super() ;
			
			resW = _resW ;
			resH = _resH ;
			numMines = _numMines ;
			if ( numMines > (resH * resW) - 1 )
				throw "invalid setup, you cannot have more mines than the resolution of the grid minus one" ;
			
			cells = new Vector.<Cell>() ;
			
			gridLayer = new Sprite() ;
			
			for ( var i:int = 0 ; i < resH ; ++i )
			{
				for ( var j:int = 0 ; j < resW ; ++j )
				{
					// this makes ii and jj copies of i and j that won't be modified next loop
					// and therefore are safe to use in an inline function
					function f(ii:int, jj:int):void
					{
						var cell:Cell = new Cell() ;
						cell.x = 25* jj ;
						cell.y = 25* ii ;
						gridLayer.addChild(cell) ;
						cell.triggered.add( function():void { onCellTriggered( jj, ii, cell ) ; } ) ;
						cells.push( cell ) ;
					}
					f(i, j) ;
				}
			}
			
			addEventListener( Event.ADDED_TO_STAGE, onAdded ) ;
			addChild( gridLayer ) ;
			
			end = new Future() ;
			
		}
		
		private function onAdded(e:Event):void
		{
			
			removeEventListener( starling.events.Event.ADDED_TO_STAGE, onAdded ) ;
			gridLayer.x = (stage.stageWidth - gridLayer.width) / 2 ;
			
		}
		
		// delayed init so the grid is generated at first click
		// to avoid first-click gameover flaw
		public function init( _initCellX : int, _initCellY : int ) : void
		{
			
			// initialize a work grid of resW*resH with 'false'
			var tempGrid : Array = [] ;
			for ( var i : int = 0 ; i < resH ; ++i )
			{
				tempGrid[i] = new Array() ;
				for ( var j : int = 0 ; j < resW ; ++j )
					tempGrid[i][j] = false ;
			}
			
			// pick up random x and y to put a mine to
			// if there is already a mine there or it's the init point, start the loop again and pick new coordinates
			// do this while there are still bombs to place
			// [NOTE] this algorithm should have very poor performances if numBombs is close to resW*resH
			//		but I guess it's ok for a reasonable bomb/resolution ratio
			var placedMines : int = 0 ;
			do {
				
				var mineX:int = Math.floor( Math.random() * resW ) ;
				var mineY:int = Math.floor( Math.random() * resH ) ;
				
				// init point, pick new coordinates
				if ( _initCellX == mineX && _initCellY == mineY )
					continue ;
				
				// there is a mine, pick new coordinates
				if ( tempGrid[mineY][mineX] )
					continue ;
				
				// everything went ok, place the mine
				tempGrid[mineY][mineX] = true ;
				++placedMines ;
				
			} while ( placedMines < numMines )
			
			// initialize the real grid with generated values
			for ( i = 0 ; i < tempGrid.length ; ++i )
			{
				for ( j = 0 ; j < tempGrid[i].length ; ++j )
				{
					
					cells[i * resW + j].init( tempGrid[i][j] ? CellType.MINE : CellType.EMPTY ) ;
					
				}
			}
			
			uncovered = 0 ;
			
			startTime = getTimer() ;
			
			initialized = true ;
			
		}
		
		private function onCellTriggered( _x : int, _y : int, _cell : Cell ) : void
		{
			
			if ( !initialized )
			{
				init( _x, _y ) ;
			}
			
			if ( !_cell.isRevealed() )
			{
				
				if ( _cell.cellType.getValue().equals( CellType.MINE ) )
				{
					
					for each( var c : Cell in cells )
					{
						c.peek() ;
					}
					_cell.reveal() ;
					endGame( false ) ;
					
				}
				else
				{
					
					reveal( _x, _y ) ;
					if ( uncovered == resW * resH - numMines )
						endGame( true ) ;
					
				}
				
			}
			
		}
		
		// prerequist : _x and _y should be valid coordinates
		// and cell at (_x,_y) should not be a mine
		private function reveal( _x : int, _y : int ) : void
		{
			
			var c:Cell = cells[ _y * resW + _x ] ;
			
			if ( c.isRevealed() )
				return ;
			
			c.reveal() ;
			++uncovered ;
			
			var hint : int = 0 ;
			
			for ( var i:int = _y - 1 ; i <= _y + 1 ; ++i )
			{
				for ( var j:int = _x -1 ; j <= _x + 1 ; ++j )
				{
					
					if ( i < 0 || i >= resH || j < 0 || j >= resW || ( i == _y && j == _x ) )
						continue ;
					
					if ( cells[i * resW + j].cellType.getValue().equals( CellType.MINE ) )
						++hint ;
					
				}
			}
			
			// if no mine in the surroundings, extend the mine-free zone to its limits
			if ( hint == 0 )
			{
				
				for ( i = _y - 1 ; i <= _y + 1 ; ++i )
				{
					for ( j = _x -1 ; j <= _x + 1 ; ++j )
					{
						
						if ( i < 0 || i >= resH || j < 0 || j >= resW || ( i == _y && j == _x ) )
							continue ;
						
						reveal( j, i ) ;
						
					}
				}
				
			}
			else
			{
				
				c.hint( hint ) ;
				
			}
			
		}
		
		private function endGame( _ok : Boolean ) : void
		{
			
			end.complete( _ok ) ;
			
		}
		
	}

}