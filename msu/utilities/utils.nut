::MSU.Utils <- {
	DataType = {
		Integer = 0,
		Float = 1,
		Boolean = 2,
		String = 3,
		Array = 4,
		Table = 5
	},

	function serialize( _object, _out )
	{
		::MSU.requireOneFromTypes(["array", "table"], _object);

		local type = typeof _object;
		local isTable = type == "table";

		if (isTable) _out.writeU8(this.DataType.Table);
		else _out.writeU8(this.DataType.Array);

		_out.writeU32(_object.len());

		foreach (key, element in _object)
		{
			if (isTable) _out.writeString(key);
			local dataType = typeof element;

			switch (dataType)
			{
				case "integer":
					_out.writeU8(this.DataType.Integer);
					if (element < 0)
					{
						_out.writeBool(true);
						_out.writeI32(element);
					}
					else
					{
						_out.writeBool(false);
						_out.writeU32(element);
					}
					break;

				case "float":
					_out.writeU8(this.DataType.Float);
					_out.writeF32(element);
					break;

				case "boolean":
					_out.writeU8(this.DataType.Boolean);
					_out.writeBool(element);
					break;

				case "string":
					_out.writeU8(this.DataType.String);
					_out.writeString(element);
					break;

				case "array":
					_out.writeU8(this.DataType.Array);
					::MSU.serialize(element, _out);
					break;

				case "table":
					_out.writeU8(this.DataType.Table);
					::MSU.serialize(element, _out);
					break;

				default:
					throw ::MSU.Exception.InvalidType(element);
			}
		}
	}

	function deserialize( _in )
	{
		local type = _in.readU8();
		local isTable = type == this.DataType.Table;
		local size = _in.readU32();

		local ret = isTable ? {} : array(size, null);

		for (local i = 0; i < size; i++)
		{
			local key = isTable ? _in.readString() : null;
			local dataType = _in.readU8();
			local val;

			switch (dataType)
			{
				case this.DataType.Integer:
					val = _in.readBool() ? _in.readI32() : _in.readU32();
					break;

				case this.DataType.Float:
					val = _in.readF32();
					break;

				case this.DataType.Boolean:
					val = _in.readBool();
					break;

				case this.DataType.String:
					val = _in.readString();
					break;

				case this.DataType.Array:
				case this.DataType.Table:
					val = ::MSU.deserialize(_in);
					break;

				default:
					throw ::MSU.Exception.InvalidType(dataType);
			}

			if (isTable) ret[key] <- val;
			else ret[i] = val;
		}

		return ret;
	}

	function getDistanceOnRoads( _start, _dest )
	{
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost;
		navSettings.RoadMult = 0.2;
		navSettings.RoadOnly = true;
		local path = this.World.getNavigator().findPath(_start, _dest, navSettings, 0);

		return path.isEmpty() ? null : path.getSize();
		// returns null if path doesn't exist
	}

	function getNeighboringSettlements( _settlement )
	{
		local start = ::Time.getExactTime()
		local settlements = ::World.EntityManager.getSettlements();
		local neighbors = [];
		local distances = {};
		// get distances to start
		foreach (settlement in settlements)
		{
			distances[settlement] <- ::MSU.Utils.getDistanceOnRoads(_settlement.getTile(), settlement.getTile());
		}

		foreach (current in settlements)
		{
			local isNeighbor = true;
			if (distances[current] == null) continue;
			foreach (settlement in settlements)
			{
				if (settlement == current || settlement == _settlement)
				{
					continue;
				}
				local distanceToSettlement = ::MSU.Utils.getDistanceOnRoads(current.getTile(), settlement.getTile())
				if (distanceToSettlement != null && (::Math.abs(distanceToSettlement + distances[settlement] - distances[current]) < 3))
				{
					isNeighbor = false;
					break;
				}
			}
			if (isNeighbor) neighbors.push(current);
		}
		foreach (neighbor in neighbors)
		{
			::logInfo("neighbor: " + neighbor.getName())
		}
		::logInfo("that took " + (::Time.getExactTime() - start));
		return neighbors;
	}
}
