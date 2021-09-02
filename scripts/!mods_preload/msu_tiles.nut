local gt = this.getroottable();

gt.Const.MSU.setupTileUtils <- function()
{
	this.MSU.Tile <- {
		function canResurrectOnTile( _tile, _force = false )
		{
			if (!_targetTile.IsCorpseSpawned) 
			{
				return false;
			}
			if (!_targetTile.Properties.get("Corpse").IsResurrectable && !_force)
			{
				return false;
			}
			
			return true;
		}
	}
}