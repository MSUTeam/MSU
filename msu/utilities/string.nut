::MSU.String <- {
	function capitalizeFirst( _string )
	{
		local string = _string.tostring();
		local first = (string).slice(0, 1);
		first = first.toupper();
		local second = (string).slice(1);
		return first + second;
	}

	function replace( _string, _find, _replace )
	{
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
}
