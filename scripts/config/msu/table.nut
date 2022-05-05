::MSU.Table <- {
	function rand( _table )
	{
		local chosenIdx = ::Math.rand(0, _table.len() - 1);
		local i = 0;
		foreach (key, value in _table)
		{
			if (i == chosenIdx) return [key, value];
			i++;
		}
	}

	function randKey( _table )
	{
		local chosenIdx = ::Math.rand(0, _table.len() - 1);
		local i = 0;
		foreach (key, value in _table)
		{
			if (i == chosenIdx) return key;
			i++;
		}
	}

	function randValue( _table )
	{
		local chosenIdx = ::Math.rand(0, _table.len() - 1);
		local i = 0;
		foreach (value in _table)
		{
			if (i == chosenIdx) return value;
			i++;
		}
	}

	function merge( _table1, _table2, _overwrite = true )
	{
		foreach (key, value in _table2)
		{
			if (!_overwrite && (key in _table1)) throw ::MSU.Exception.DuplicateKey(key);
			_table1[key] <- value;
		}
	}

	function keys( _table )
	{
		local ret = array(_table.len());
		local i = 0;
		foreach (key, value in _table)
		{
			ret[i] = key;
			i++;
		}
	}

	function values( _table )
	{
		local ret = array(_table.len());
		local i = 0;
		foreach (value in _table)
		{
			ret[i] = value;
			i++;
		}
	}

	function apply( _table, _function )
	{
		// _function (_key, _value)
		// must return new value for _key

		foreach (key, value in _table)
		{
			_table[key] = _function(key, value);
		}
	}

	function filter( _table, _function )
	{
		// _function (_key, _value)
		// must return boolean

		local ret = {};
		foreach (key, value in _table)
		{
			if (_function(key, value)) ret[key] <- value;
		}

		return ret;
	}	

	function map( _table, _function )
	{
		// _function (_key, _value)
		// must a len 2 array with idx 0 being new key and idx 1 being its value
		
		local ret = {};
		foreach (key, value in _table)
		{
			local pair = _function(key, value);
			ret[pair[0]] <- pair[1];
		}

		return ret;
	}
}
