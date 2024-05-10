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

	function getTilesWithinRange( _tile, _max = 1, _min = 1 )
	{
		if (_max < _min || _max < 0 || _min < 0)
		{
			::logError("_max and _min must be positive and _max must be equal to or greater than _min");
			throw ::MSU.Exception.InvalidValue(_max);
		}

		if (_max == 1)
			return this.getNeighbors(_tile);

		local ret = [];

		local mapSize = ::Tactical.getMapSize();
		for (local x = ::Math.max(0, _tile.SquareCoords.X - _max); x < mapSize.X; x++)
		{
			local xDist = ::Math.abs(_tile.SquareCoords.X - x);
			if (xDist < _min)
				xDist = ::Math.min(mapSize.X, _tile.SquareCoords.X + _max);
			else if (xDist > _max)
				break;

			for (y = ::Math.max(0, _tile.SquareCoords.Y - _max); y < mapSize.Y; y++)
			{
				local yDist = ::Math.abs(_tile.SquareCoords.Y - y);
				if (yDist < _min)
					yDist = ::Math.min(mapSize.Y, _tile.SquareCoords.Y + _max);
				else if (yDist > _max)
					break;

				ret.push(::Tactical.getTileSquare(x, y));
			}
		}

		return ret;
	}
}
