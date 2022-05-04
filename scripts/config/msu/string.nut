::MSU.String <- {
	function capitalizeFirst( _string )
	{
		if (_string == "") return _string;
		local first = _string.slice(0, 1);
		first = first.toupper();
		return first + _string.slice(1);
	}

	function replace( _string, _find, _replace, _all = false )
	{
		local idx;
		do
		{
			idx = _string.find(_find);
			_string = idx == null ? _string : _string.slice(0, idx) + _replace + _string.slice(idx + _find.len());
		}
		while(idx != null && _all)
		return _string;
	}

	function isInteger( _string )
	{
		foreach (char in _string)
		{
			if (char < 48 || char > 57) return false;
		}
		return true;
	}
}
