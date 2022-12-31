::MSU.Tile <- {
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

	function getNeighbors( _tile )
	{
		local ret = [];
		for (local i = 0; i < 6; i++)
		{
			if (_tile.hasNextTile(i))
				ret.push(_tile.getNextTile(i));
		}
		return ret;
	}

	function getNeighbor( _tile, _function )
	{
		// _function( tile ) and returns boolean

		for (local i = 0; i < 6; i++)
		{
			if (_tile.hasNextTile(i))
			{
				local nextTile = _tile.getNextTile(i);
				if (_function(nextTile)) return nextTile;
			}
		}
	}
}
