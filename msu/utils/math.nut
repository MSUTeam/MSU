::MSU.Math <- {
	// returns log2 of _num, floored (as an int)
	function log2int( _num )
	{
		local count = 0;
		while (_num > 1) 
		{
			_num = _num >> 1;
			count++;
		}
		return count;
	}

	// Returns the normalized value of the normal distribution at _x
	function normalDistNorm( _x, _mean, _std )
	{
		return exp(-0.5 * pow((_x - _mean)/_std.tofloat(), 2));
	}

	// Returns the value of the normal distribution at _x
	function normalDist( _x, _mean, _std )
	{
		return exp(-0.5 * pow((_x - _mean)/(_std * 1.0), 2)) / (_std * sqrt(2 * 3.14));			
	}

	function randf( _min, _max )
	{
		::MSU.requireFloat(_min, _max);
		return _min + (::Math.rand(0, 2147483647) / 2147483647.0) * (_max - _min);
	}

	function roundToSig( _num, _significantFigures )
	{
		::MSU.requireInt(_significantFigures);
		if (_num == 0)
			return 0;

		local d = ::ceil(::log10(::fabs(_num))).tointeger(); // tointeger to prevent floating point accuracy issues
		local magnitude = ::pow(10, _significantFigures - d);
		return ::Math.round(_num * magnitude) / magnitude;
	}

	function roundToMult( _num, _multiple )
	{
		if (_multiple <= 0)
		{
			::logError("_multiple must be greater than 0");
			throw ::MSU.Exception.InvalidValue(_multiple);
		}

		local num = ::fabs(_num);
		local rem = num % _multiple;
		local ret = rem < _multiple * 0.5 ? num - rem : num + _multiple - rem;
		return _num < 0 ? -ret : ret;
	}

	function roundToDec( _num, _decimalPlaces )
	{
		::MSU.requireInt(_decimalPlaces);
		if (_decimalPlaces < 0)
		{
			::logError("_decimalPlaces must be >= 0");
			throw ::MSU.Exception.InvalidValue(_decimalPlaces);
		}

		local tens = ::pow(10, _decimalPlaces);
		return ::Math.round(tens * _num) / tens;
	}

	function truncf( _num, _decimalPlaces )
	{
		::MSU.requireInt(_decimalPlaces);
		if (_decimalPlaces < 0)
		{
			::logError("_decimalPlaces must be >= 0");
			throw ::MSU.Exception.InvalidValue(_decimalPlaces);
		}

		local tens = ::pow(10, _decimalPlaces);
		return ::Math.floor(tens * _num) / tens;
	}

	// The return has the same type as that of _value
	function clamp( _value, _min, _max )
	{
		// Swap _min and _max if the user gave the values in wrong order.
		if (_min > _max)
		{
			local max = _max;
			_max = _min;
			_min = max;
		}

		local ret = _value < _min ? _min : (_value > _max ? _max : _value);
		return typeof _value == "integer" ? ret.tointeger() : ret.tofloat();
	}
};
