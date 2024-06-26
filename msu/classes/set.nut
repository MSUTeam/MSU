::MSU.Class.Set <- class
{
	Table = null; // Cannot contain null

	constructor( _tableOrArray = null )
	{
		this.Table = {};
		if (_tableOrArray != null)
		{
			switch (typeof _tableOrArray)
			{
				case "table":
					foreach (key, _ in _tableOrArray)
						this.add(key);
					break;

				case "array":
					foreach (item in _tableOrArray)
						this.add(item);
					break;

				default:
					throw ::MSU.Exception.InvalidType(_tableOrArray);
			}
		}
	}

	function _cloned( _original )
	{
		this.Table = clone _original.Table;
	}

	// Used for iterating over the set e.g. foreach (item in mySet.toArray())
	// We don't implement _nexti because of two reasons:
	// - It is orders of magnitude slower than iterating on a table
	// - It is not compatible with nested foreach loops where you have a "break" in the nested loop
	function toArray()
	{
		return ::MSU.Table.keys(this.Table);
	}

	function add( _item )
	{
		this.Table[_item] <- false;
	}

	function remove( _item )
	{
		if (!(_item in this.Table))
			throw ::MSU.Exception.KeyNotFound(_item);
		delete this.Table[_item];
	}

	function contains( _item )
	{
		return _item in this.Table;
	}

	function apply( _function )
	{
		// _function ( _item )
		// must return value that will replace _item in this set

		local newTable = {};
		foreach (item, _ in this.Table)
		{
			newTable[_function(item)] <- false;
		}
		this.Table = newTable;
	}

	function map( _function )
	{
		// _function ( _item )
		// must return value that will be stored in the returned set instead of _item

		local ret = ::MSU.Class.Set();
		foreach (item, _ in this.Table)
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
		foreach (item, _ in this.Table)
		{
			if (_function(item)) ret.add(item);
		}
		return ret;
	}
}
