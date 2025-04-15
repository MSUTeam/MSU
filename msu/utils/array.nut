::MSU.Array <- {
	function rand( _array, _start = null, _end = null )
	{
		local len = _array.len();
		if (len == 0)
		{
			if (_start != null || _end != null) throw "indexing empty array";
			return null;
		}

		if (_start == null) _start = 0;
		else if (_start >= len || -_start > len)
		{
			::logError("starting index out of bounds");
			throw ::MSU.Exception.InvalidValue(_start);
		}
		else if (_start < 0) _start = len + _start;

		if (_end == null) _end = len;
		else if (_end > len || -_end > len)
		{
			::logError("ending index out of bounds");
			throw ::MSU.Exception.InvalidValue(_end);
		}
		else if (_end < 0) _end = len + _end;

		if (_start >= _end)
		{
			::logError("invalid indices: _start must be smaller than _end");
			throw ::MSU.Exception.InvalidValue(_end);
		}

		return _array[::Math.rand(_start, _end - 1)];
	}


	// deprecated - use removeByValue instead
	function remove( _array, _item, _ignoreMissing = true )
	{
		local idx = _array.find(_item);
		if (idx == null)
		{
			if (!_ignoreMissing) throw ::MSU.Exception.KeyNotFound(_item);
			return null;
		}
		else
		{
			return _array.remove(idx);
		}
	}

	function removeByValue( _array, _item )
	{
		local idx = _array.find(_item);
		if (idx != null) return _array.remove(idx);
	}

	function removeValues( _array, _values )
	{
		for (local i = _array.len() - 1; i >= 0; i--)
		{
			if (_values.find(_array[i]) != null)
			{
				_array.remove(i);
			}
		}
		return _array;
	}

	function shuffle( _array )
	{
		for (local i = _array.len() - 1; i > 0; i--)
		{
			local j = ::Math.rand(0, i);

			local temp = _array[i];
			_array[i] = _array[j];
			_array[j] = temp;
		}
	}

	// Unlike squirrel array.sort, this preserves the order of equal members and also returns the array at the end.
	// Uses Insertion Sort algorithm. Merge Sort is slow in squirrel even for large arrays (even len 1000 array is ~1000% slower than Insertion Sort).
	// A hybrid of Insertion and Merge is also considerably slower than pure Insertion (~700% slower for 1000 len array).
	function stableSort( _array, _compareFunc = null )
	{
		if (_array.len() <= 1)
			return _array;

		local len = _array.len();
		for (local i = 1; i < len; i++)
		{
			local key = _array[i];
			local j = i - 1;

			while (j >= 0 && (_compareFunc ? _compareFunc(_array[j], key) > 0 : _array[j] > key))
			{
				_array[j + 1] = _array[j];
				j--;
			}

			_array[j + 1] = key;
		}

		return _array;
	}

	function sortDescending( _array, _member = null )
	{
		if (_member == null)
		{
			_array.sort(@(a, b) -1 * (a <=> b));
		}
		else
		{
			if (_array.len() != 0 && typeof _array[0][_member] == "function")
			{
				_array.sort(@(a, b) -1 * (a[_member]() <=> b[_member]()));
			}
			else
			{
				_array.sort(@(a, b) -1 * (a[_member] <=> b[_member]));
			}
		}
	}

	function sortAscending( _array, _member = null )
	{
		if (_member == null)
		{
			_array.sort();
		}
		else
		{
			if (_array.len() != 0 && typeof _array[0][_member] == "function")
			{
				_array.sort(@(a, b) a[_member]() <=> b[_member]());
			}
			else
			{
				_array.sort(@(a, b) a[_member] <=> b[_member]);
			}
		}
	}

	// Returns a new array
	function uniques( _array )
	{
		local hasNull = false;
		local t = {};
		local ret = [];
		foreach (e in _array)
		{
			if (e == null)
			{
				if (!hasNull)
				{
					ret.push(null);
					hasNull = true;
				}
			}
			else if (!(e in t))
			{
				t[e] <- true;
				ret.push(e);
			}
		}

		return ret;
	}
}
