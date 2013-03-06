package game 
{
	
	/**
	 * this is a type-safe enum
	 * 
	 * @author Renaud Bardet
	 */
	
	public class CellType 
	{
		
		public static const EMPTY : CellType = new CellType( 0 ) ;
		public static const MINE : CellType = new CellType( 1 ) ;
		
		private var id : int ;
		
		// you shouldn't use this constructor, so please don't
		public function CellType( _id : int ) 
		{
			
			id = _id ;
			
		}
		
		public function equals( _x : CellType ) : Boolean
		{
			
			return id == _x.id ;
			
		}
		
	}

}