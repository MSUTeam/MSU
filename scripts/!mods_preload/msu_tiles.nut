local gt = this.getroottable();

gt.Const.MSU.setupTileUtils <- function()
{
	this.Const.TileUtils <- {
		function canResurrectOnTile( _tile, _force = false )
		{
			if (!_targetTile.IsCorpseSpawned) return false;
			if (!_targetTile.Properties.get("Corpse").IsResurrectable && !_force) return false;
			if (_targetTile.Properties.Effect.Type == "legend_holyflame") return false;
			
			return true;
		}
	}
}