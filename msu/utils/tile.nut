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
				ret.push(_tile.getNextTile());
		}
		return ret;
	}

	function getNeighbor( _tile, _function = null )
	{
		// _function( tile ) returns boolean
		// iterates over all neighboring tiles and calls _function on each tile
		// returns the first tile for which _function returned true

		for (local i = 0; i < 6; i++)
		{
			if (_tile.hasNextTile(i))
			{
				local nextTile = _tile.getNextTile(i);
				if (_function == null || _function(nextTile))
					return nextTile;
			}
		}
	}

	function getRandomNeighbor( _tile )
	{
		return ::MSU.Array.rand(this.getNeighbors(_tile));
	}
}
