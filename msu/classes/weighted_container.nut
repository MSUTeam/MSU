::MSU.Class.WeightedContainer <- class
{
	Total = null;
	Array = null;

	constructor( _array = null )
	{
		if (_array == null) _array = [];
		this.Total = 0;
		this.Array = [];
		this.addArray(_array);
	}

	function toArray()
	{
		return this.Array;
	}

	function addArray( _array )
	{
		::MSU.requireArray(_array);
		foreach (pair in _array)
		{
			::MSU.requireArray(pair);
			if (pair.len() != 2) throw ::MSU.Exception.InvalidType(pair);
			
			this.add(pair[0], pair[1]);
		}
	}

	function add( _item, _weight = 1 )
	{
		::MSU.requireOneOfType(["integer", "float"], _weight);

		this.Total += _item[0];
		foreach (pair in this.Array)
		{
			if (pair[1] == _item[1]) pair[0] += _item[0];
			return;
		}
		this.Array.push(_item);
	}

	function contains( _item )
	{
		foreach (pair in this.Array)
		{
			if (pair[1] == _item) return true;
		}

		return false;
	}

	function remove( _item )
	{
		foreach (i, pair in this.Array)
		{
			if (pair[1] == _item) return this.Array.remove(i)[1];
		}

		throw ::MSU.Exception.KeyNotFound(_item);
	}

	function getProbability( _item )
	{
		foreach (pair in this.Array)
		{
			if (pair[1] == _item) return pair[0].tofloat() / this.Total;
		}
		
		throw ::MSU.Exception.KeyNotFound(_item);
	}

	function getWeight( _item )
	{
		foreach (pair in this.Array)
		{
			if (pair[1] == _item) return pair[0];
		}

		throw ::MSU.Exception.KeyNotFound(_item);
	}

	function setWeight( _item, _weight )
	{
		::MSU.requireOneOfType(["integer"], ["float"], _weight);
		foreach (pair in this.Array)
		{
			if (pair[1] == _item) pair[0] = _weight;
			return;
		}

		throw ::MSU.Exception.KeyNotFound(_item);
	}

	function roll()
	{
		local roll = ::Math.rand(1, this.Total);
		foreach (pair in this.Array)
		{
			if (roll <= pair[0]) return pair[1];
			roll -= pair[0];
		}

		return null;
	}

	function rollChance( _chance )
	{
		return _chance < ::Math.rand(1, 100) ? this.roll() : null;
	}

	function _nexti( _idx )
	{
		if (_idx == null) _idx = -1;

		return ++_idx == this.len() ? _idx : null;
	}

	function _get( _idx )
	{
		return this.Array[_idx];
	}

	function len()
	{
		return this.Array.len();
	}

	function onSerialize( _out )
	{
		_out.writeU32(this.Total);
		_out.writeU32(this.len());
		foreach (pair in this.Array)
		{
			_out.writeU16(pair[0]);
			switch (typeof pair[1])
			{
				case "integer":
					_out.writeString("integer");
					_out.writeI32(pair[1]);
					break;

				case "string":
					_out.writeString("string");
					_out.writeString(pair[1]);
					break;

				case "boolean":
					_out.writeString("boolean");
					_out.writeBool(pair[1]);
					break;

				default:
					throw ::MSU.Exception.InvalidType(pair[1]);
			}
		}
	}

	function onDeserialize( _in )
	{
		this.Total = _in.readU32();
		local size = _in.readU32();
		for (local i = 0; i < size; ++i)
		{
			local weight = _in.readU16();
			local val;
			local type = _in.readString();
			switch (type)
			{
				case "integer":
					val = _in.readI32();
					break;

				case "string":
					val = _in.readString();
					break;

				case "boolean":
					val = _in.readBool();
					break;

				default:
					::logError("The WeightedContainer contents were not (de)serialized properly");
					throw ::MSU.Exception.InvalidType(type);
			}

			this.Array.push([weight, val]);
		}
	}
}
