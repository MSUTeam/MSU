local gt = this.getroottable();

gt.MSU.setupTileUtils <- function()
{
	this.MSU.Tile <- {
		function canResurrectOnTile( _tile, _force = false )
		{
			if (!_tile.IsCorpseSpawned) 
			{
				return false;
			}
			if (!_tile.Properties.get("Corpse").IsResurrectable && !_force)
			{
				return false;
			}
			
			return true;
		}
	}
}