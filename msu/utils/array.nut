::MSU.Array <- {
	function rand( _array, _start = 0, _end = null )
	{
		local len = _array.len();
		if (_start >= len || -_start > len)
		{
			::logError("starting index out of bounds");
			throw ::MSU.Exception.InvalidValue(_start);
		}

		if (_end == null) _end = len;
		else if (_end > len || -_end > len)
		{
			::logError("ending index out of bounds");
			throw ::MSU.Exception.InvalidValue(_end);
		}

		if (_start < 0) _start = len + _start;
		if (_end < 0) _end = len + _end;

		if (_start >= _end)
		{
			::logError("invalid indices: _start must be smaller than _end");
			throw ::MSU.Exception.InvalidValue(_end);
		}

		return len == 0 ? null : _array[::Math.rand(_start, _end - 1)];
	}

	// Deprecated, use removeElement instead
	function remove( _array, _item, _ignoreMissing = true )
	{
		this.removeElement(_array, _item, _ignoreMissing = true);
		return _item;
	}

	function removeElement( _array, _item, _ignoreMissing = true )
	{
		local idx;
		local isFirst = true;
		do
		{
			idx = _array.find(_item);
			if (idx != null) _array.remove(idx);
			else if (isFirst && !_ignoreMissing) throw ::MSU.Exception.KeyNotFound(_item);
			isFirst = false;
		} while (idx != null)
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
}
