::MSU.Class.Set <- class
{
	Table = null;
	Array = null;

	constructor( _table = null )
	{
		if (_table != null)
		{
			::MSU.requireTable(_table);
			foreach (key, value in _table)
			{
				this.Table[key] <- null;
				this.Array.push(key);
			}
		}
	}

	function _get( _idx )
	{
		if (_idx == "weakref") throw null;
		return this.Array[_idx];
	}

	function _cloned( _original )
	{
		this.Table = clone _original.Table;
		this.Array = clone _original.Array;
	}

	function _nexti( _prev )
	{
		_prev = _prev == null ? 0 : _prev + 1;
		return _prev == this.Array.len() ? null : _prev;
	}

	function add( _item )
	{
		if (_item in this.Table) throw ::MSU.Exception.DuplicateKey(_item);
		this.Table[_item] <- null;
		this.Array.push(_item);
	}

	function remove( _item )
	{
		if (!(_item in this.Table)) throw ::MSU.Exception.KeyNotFound(_item);
		delete this.Table[_item];
		this.Array.remove(this.Array.find(_item));
	}

	function contains( _item )
	{
		return _item in this.Table;
	}

	function toArray()
	{
		return clone this.Array;
	}

	function apply( _function )
	{
		// _function ( _item )
		// must return value that will replace _item in this set

		foreach (i, item in this.Array)
		{
			delete this.Table[item];
			local newVal = _function(item);
			this.Array[i] = newVal;
			this.Table[newVal] <- null;
		}
	}

	function map( _function )
	{
		// _function ( _item )
		// must return value that will be stored in the returned set instead of _item

		local ret = ::MSU.Class.Set();
		foreach (item in this.Array)
		{
			ret.add(_function(item))
		}
		return ret;
	}

	function filter( _function )
	{
		// _function ( _item  )
		// must return a boolean, if false then _item is not added to the returned set

		local ret = ::MSU.Class.Set();
		foreach (item in this.Array)
		{
			if (_function(item)) ret.add(item);
		}
		return ret;
	}
}
