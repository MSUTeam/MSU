::MSU.Array <- {
	function rand( _array, _start = 0, _end = null )
	{
		if (_array.len() == 0) return null;
		local start = _start;
		local end = _end;

		if (end == null) end = _array.len();
		if (end < 0) end = _array.len() - end;
		if (start < 0) start = _array.len() - start;
		
		if (start < 0 || end < start)
		{
			throw "Invalid indices. _array.len() = " + _array.len();
		}

		return _array[::Math.rand(start, end - 1)];
	}

	function shuffle( _array )
	{
		for (local i = _array.len() - 1; i > 0; i--)
		{
			local j = ::Math.rand(0, i);

			local temp = _array[i];
			_array[i] = _array[j];
			_array[j]  = temp;
		}
	}

	function sortDescending( _array, _member = null )
	{
		if (_member == null)
		{
			_array.sort(function(_a, _b) { if (_a < _b) return -1; if (_a > _b) return 1; return 0 });
		}
		else
		{
			_array.sort(function(_a, _b) { if (_a[_member] > _b[_member]) return -1; if (_a[_member] < _b[_member]) return 1; return 0 });	
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
			_array.sort(function(_a, _b) { if (_a[_member] > _b[_member]) return 1; if (_a[_member] < _b[_member]) return -1; return 0 });	
		}
	}
}
