::MSU.Text <- {
	function color( _color, _string )
	{
		return "[color=" + _color + "]" + _string + "[/color]";
	}

	function colorGreen( _string )
	{
		return this.color(::Const.UI.Color.PositiveValue, _string);
	}

	function colorRed( _string )
	{
		return this.color(::Const.UI.Color.NegativeValue, _string);
	}

	function colorizeValue( _value, _addSign = true, _compareTo = 0, _invertColor = false, _addPercent = false )
	{
		if (_value < _compareTo)
		{
			if (!_addSign && _value < 0) _value *= -1;
			if (_addPercent) _value = _value + "%";
			return _invertColor ? this.colorGreen(_value) : this.colorRed(_value);
		}

		if (_value > _compareTo)
		{
			if (_addSign && _value > 0) _value = "+" + _value;
			if (_addPercent) _value = _value + "%";			
			return _invertColor ? this.colorRed(_value) : this.colorGreen(_value);
		}

		if (_value == _compareTo)
		{
			if (_addPercent) _value = _value + "%";
			return _value;
		}
	}

	function colorizePercentage( _value, _addSign = true, _compareTo = 0, _invertColor = false )
	{
		return this.colorizeValue(_value, _compareTo, _addSign, _invertColor, true);
	}
}
