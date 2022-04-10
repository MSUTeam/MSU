::MSU.Class.WeightedContainer <- class
{
	Total = null;
	Array = null;
	ApplyIdx = null;

	constructor( _array = null )
	{
		if (_array == null) _array = [];
		this.Total = 0;
		this.Array = [];
		this.addArray(_array);
	}

	function toArray( _itemsOnly = true )
	{
		local ret = array(this.Array.len(), null);
		foreach (i, pair in this.Array)
		{
			if (_itemsOnly) ret[i] = pair[1];
			else ret[i] = [pair[0], pair[1]];
		}
		return ret;
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
		::MSU.requrieOneFromTypes(["integer", "float"], _weight);

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
		local weight = null;
		if (this.ApplyIdx != null && this.Array[this.ApplyIdx][1] == _item)
		{
			weight = this.Array[this.ApplyIdx][0];
		}
		else
		{
			foreach (pair in this.Array)
			{
				if (pair[1] == _item) weight = pair[0];
			}
		}

		if (weight != null) return weight.tofloat() / this.Total;
		
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
		::MSU.requrieOneFromTypes(["integer"], ["float"], _weight);

		if (this.ApplyIdx != null && this.Array[this.ApplyIdx][1] == _item)
		{
			this.Array[this.ApplyIdx][0] = _weight;
			return;
		}

		foreach (pair in this.Array)
		{
			if (pair[1] == _item) pair[0] = _weight;
			return;
		}

		throw ::MSU.Exception.KeyNotFound(_item);
	}

	function apply( _function )
	{
		// _function (_item, _weight)

		foreach (i, pair in this.Array)
		{
			this.ApplyIdx = i;
			_function(pair[1], pair[0]);
		}

		this.ApplyIdx = null;
	}

	function map( _function )
	{
		// _function (_item, _weight)

		local ret = ::MSU.Class.WeightedContainer();
		foreach (i, pair in this.Array)
		{
			this.ApplyIdx = i;
			ret.add(_function(pair[1], pair[0]));
		}
		this.ApplyIdx = null;
		return ret;
	}

	function filter( _function )
	{
		// _function (_item, _weight)

		local ret = ::MSU.Class.WeightedContainer();
		foreach (i, pair in this.Array)
		{
			this.ApplyIdx = i;
			if (_function(pair[1], pair[0])) ret.add(pair[1], pair[0]);
		}
		this.ApplyIdx = null;
		return ret;
	}

	function clear()
	{
		this.Total = 0;
		this.Array.clear();
	}

	function top()
	{
		local weight = 0;
		local ret;

		foreach (pair in this.Array)
		{
			if (pair[0] > weight)
			{
				weight = pair[0];
				ret = pair[1];
			}
		}

		return ret;
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

	function _cloned()
	{
		return ::MSU.Class.WeightedContainer(clone this.Array);
	}

	function len()
	{
		return this.Array.len();
	}

	function onSerialize( _out )
	{
		_out.writeU32(this.Total);
		::MSU.System.Serialization.serializeObject(this.Array, _out);
	}

	function onDeserialize( _in )
	{
		this.Total = _in.readU32();
		this.Array = ::MSU.System.Serialization.deserializeObject(_in);
	}
}
