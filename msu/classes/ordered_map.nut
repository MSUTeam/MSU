::MSU.Class.OrderedMap <- class
{
	Array = null;
	Table = null;
	IIndexStack = null;

	constructor( _table = null )
	{
		this.Array = [];
		this.Table = {};
		this.IIndexStack = [];
		if (_table != null) this.addTable(_table);
	}

	function _newslot( _key, _value )
	{
		if (_key in this.getclass())
		{
			::logError(_key + " is a reserved keyword in this class");
			throw ::MSU.Exception.InvalidValue(_key);
		}

		if (!(_key in this.Table))
		{
			this.Array.push(_key);
		}
		this.Table[_key] <- _value;
	}

	function _delslot( _key )
	{
		this.Array.remove(this.Array.find(_key));
		return delete this.Table[_key];
	}

	function _set( _key, _value )
	{
		this.Table[_key] = _value;
	}

	function _get( _key )
	{
		if (_key in this.Table) return this.Table[_key];
		throw null;
	}

	function _nexti( _prev )
	{
		if (_prev == null) this.IIndexStack.push(0);
		_prev = this.IIndexStack[this.IIndexStack.len() - 1]++;
		if (_prev == this.Array.len())
		{
			this.IIndexStack.pop();
			return null;
		}
		return this.Array[_prev];
	}

	function _cloned( _original )
	{
		this.Array = clone _original.Array;
		this.Table = clone _original.Table;
	}

	function toTable()
	{
		return clone this.Table;
	}

	function addTable( _table, _overwrite = true )
	{
		::MSU.requireTable(_table);
		
		foreach (key, value in _table)
		{
			if (!_overwrite && this.contains(key)) throw ::MSU.Exception.DuplicateKey(key);
			this[key] <- value;
		}
	}

	function sort( _function )
	{
		for (local i = 1; i < this.Array.len(); ++i)
		{
			local key = this.Array[i];
			local j = i - 1;
			while (j >= 0 && _function(key, this.Table[key], this.Array[j], this.Table[this.Array[j]]) < 0)
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
		// must return new value for _key

		foreach (i, key in this.Array)
		{
			this.Table[key] = _function(key, this.Table[key], i);
		}
	}

	function filter( _function )
	{
		// _function (_key, _val, _idx)
		// must return a boolean

		local ret = ::MSU.Class.OrderedMap();
		foreach (i, key in this.Array)
		{
			local val = this.Table[key];
			if (_function(key, val, i)) ret[key] <- val;
		}
		return ret;
	}

	function map( _function )
	{
		// _function (_key, _val, _idx)
		// must return a length 2 array with index 0 being new key and index 1 being new value

		local ret = ::MSU.Class.OrderedMap();
		foreach (i, key in this.Array)
		{
			local pair = _function(key, this.Table[key], i);
			ret[pair[0]] <- ret[pair[1]];
		}
		return ret;
	}

	function values()
	{
		local ret = array(this.Array.len());
		foreach (i, key in this.Array)
		{
			ret[i] = this.Table[key];
		}
		return ret;
	}

	function keys()
	{
		return clone this.Array;
	}

	function onSerialize( _out )
	{
		::MSU.Utils.serialize(this.Array, _out);
		::MSU.Utils.serialize(this.Table, _out);
	}

	function onDeserialize( _in )
	{
		this.Array = ::MSU.Utils.deserialize(_in);
		this.Table = ::MSU.Utils.deserialize(_in);
	}
}
