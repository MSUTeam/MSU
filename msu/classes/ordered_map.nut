::MSU.Class.OrderedMap <- class
{
	Array = null;
	Table = null;
	constructor()
	{
		this.Array = [];
		this.Table = {};
	}

	function _newslot( _key, _value )
	{
		if (!(_key in this.Table))
		{
			this.Array.push(_key);
		}
		this.Table[_key] <- _value;
	}

	function _delslot( _key )
	{
		this.Array.remove(this.Array.find(_key));
		delete this.Table[_key];
	}

	function _set( _key, _value )
	{
		this.Table[_key] = _value;
	}

	function _get( _key )
	{
		return this.Table[_key]
	}

	function _nexti( _prev )
	{
		_prev = _prev == null ? 0 : this.Array.find(_prev) + 1;

		return _prev == this.Array.len() ? null : this.Array[_prev];
	}

	function sort( _function )
	{
		for (local i = 1; i < this.Array.len(); ++i)
		{
			local key = this.Array[i];
			local j = i - 1;
			while (j >= 0 && _function(key, this.Table[key], this.Array[j], this.Table[this.Array[j]]) <= 0)
			{
				this.Array[j+1] = this.Array[j];
				--j;
			}

			this.Array[j+1] = key;
		}
	}

	function reverse()
	{
		this.Array.reverse();
	}

	function clear()
	{
		this.Array.clear();
		this.Table.clear();
	}

	function shuffle()
	{
		::MSU.Array.shuffle(this.Array);
	}

	function len()
	{
		return this.Array.len();
	}

	function contains( _key )
	{
		return _key in this.Table;
	}

	function apply( _function )
	{
		// _function (_key, _val, _idx)

		foreach (i, key in this.Array)
		{
			_function(key, this.Table[key], i);
		}
	}

	function filter( _function )
	{
		// _function (_key, _val)

		local ret = ::MSU.Class.OrderedMap();
		foreach (key in this.Array)
		{
			local val = this.Table[key];
			if (_function(key, val)) ret[key] <- val;
		}
		return ret;
	}

	function map( _function )
	{
		// _function (_key, _val, _idx)

		local ret = this.filter(@(key, val) return true);
		ret.apply(_function);
		return ret;
	}
}
