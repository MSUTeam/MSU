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
			if (array.len() != 2) throw ::MSU.Exception.InvalidType(_array);
			
			this.add(pair[0], pair[1]);
		}
	}

	function add( _item, _weight = 1 )
	{
		::MSU.requireOneOfType(["integer", "float"], _weight);

		this.Total += _weight;
		if !(this.contains(_item)) this.Array.push([_weight, _item]);
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
			if (pair[1] == _item) return pair[1].tofloat() / this.Total;
		}
		
		throw ::MSU.Exception.KeyNotFound(_item);
	}

	function addWeight( _weight, _function )
	{
		foreach (pair in this.Array)
		{
			if (_function(pair[1])) pair[0] += _weight;
		}
	}

	function multiplyWeight( _multiplier, _function )
	{
		foreach (pair in this.Array)
		{
			if (_function(pair[1])) pair[0] *= _multiplier;
		}
	}

	function setWeight( _weight, _function )
	{
		foreach (pair in this.Array)
		{
			if (_function(pair[1])) pair[0] = _weight;
		}
	}

	function getWeight( _item )
	{
		foreach (pair in this.Array)
		{
			if (pair[1] == _item) return pair[0];
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
			_out.writeString(pair[1]);
		}
	}

	function onDeserialize( _in )
	{
		this.Total = _in.readU32();
		local size = _in.readU32();
		for (local i = 0; i < size; ++i)
		{
			this.Array.push([_in.readU16(), _in.readString()]);
		}
	}
}
