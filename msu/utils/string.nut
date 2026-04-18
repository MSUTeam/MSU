::MSU.String <- {
	function capitalizeFirst( _string )
	{
		if (_string == "") return _string;
		return _string.slice(0, 1).toupper() + _string.slice(1);
	}

	function replace( _string, _find, _replace, _all = false )
	{
		if (_all) return ::String.replace(_string, _find, _replace);
		local idx = _string.find(_find);
		if (idx != null)
		{
			return _string.slice(0, idx) + _replace + _string.slice(idx + _find.len());
		}
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

	function startsWith( _string, _start )
	{
		return _string.find(_start) == 0;
	}

	function endsWith( _string, _end )
	{
		return _end.len() <= _string.len() && _string.slice(-_end.len()) == _end;
	}

	function split( _string, _delimiter, _skipEmpty = true )
	{
		if (_string == "")
			return [];

		if (_delimiter.len() == 1 && _skipEmpty)
			return ::split(_string, _delimiter);

		local ret = [];
		local idx;
		while ((idx = _string.find(_delimiter)) != null)
		{
			local val = _string.slice(0, idx);
			if (!_skipEmpty || val != "")
			{
				ret.push(val);
			}
			_string = _string.slice(idx + _delimiter.len());
		}

		if (!_skipEmpty || _string != "")
		{
			ret.push(_string);
		}

		return ret;
	}
}
