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
		for (local i = 0; i < this.Array; ++i)
		{
			if (this.Array[i] == _key)
			{
				this.Array.remove(i);
				delete this.Table[_key];
				return;
			}
		}
		throw ::MSU.Exception.KeyNotFound;
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
}
