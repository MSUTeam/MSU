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
		{
			local ret = this.getNeighbors(_tile);
			if (_min == 0)
				ret.push(_tile);
			return ret;
		}

		local ret = [];

		local mapSize = ::Tactical.getMapSize();
		local mapX = mapSize.X;
		local mapY = mapSize.Y;
		local originX = _tile.SquareCoords.X;
		local originY = _tile.SquareCoords.Y;

		for (local x = ::Math.max(0, originX - _max); x < mapX; x++)
		{
			local xDist = ::abs(originX - x);
			if (xDist < _min)
				xDist = ::Math.min(mapX, originX + _max);
			else if (xDist > _max)
				break;

			for (y = ::Math.max(0, originY - _max); y < mapY; y++)
			{
				local yDist = ::abs(originY - y);
				if (yDist < _min)
					yDist = ::Math.min(mapY, originY + _max);
				else if (yDist > _max)
					break;

				ret.push(::Tactical.getTileSquare(x, y));
			}
		}

		return ret;
	}
}
