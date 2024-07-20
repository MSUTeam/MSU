::MSU.Text <- {
	Color = {
		Green = "#135213",
		Red = "#8f1e1e"
	},

	function color( _color, _string )
	{
		return ::Const.UI.getColorized(_string, _color);
	}

	function colorGreen( _string )
	{
		return this.color(this.Color.Green, _string);
	}

	function colorRed( _string )
	{
		return this.color(this.Color.Red, _string);
	}

	function colorPositive( _string )
	{
		return this.color(::Const.UI.Color.PositiveValue, _string);
	}

	function colorNegative( _string )
	{
		return this.color(::Const.UI.Color.NegativeValue, _string);
	}

	function colorDamage( _string )
	{
		return this.color(::Const.UI.Color.DamageValue, _string);
	}

	function colorizeValue( _value, _kwargs = null )
	{
		local kwargs = {
			AddSign = true,
			CompareTo = 0,
			Invert = false,
			AddPercent = false
		};

		if (_kwargs != null)
		{
			foreach (key, value in _kwargs)
			{
				if (!(key in kwargs)) throw "invalid parameter " + key;
				kwargs[key] = value;
			}
		}

		if (_value < kwargs.CompareTo)
		{
			if (!kwargs.AddSign && _value < 0) _value *= -1;
			if (kwargs.AddPercent) _value = _value + "%";
			return kwargs.Invert ? this.colorGreen(_value) : this.colorRed(_value);
		}

		if (_value > kwargs.CompareTo)
		{
			if (kwargs.AddSign && _value > 0) _value = "+" + _value;
			if (kwargs.AddPercent) _value = _value + "%";
			return kwargs.Invert ? this.colorRed(_value) : this.colorGreen(_value);
		}

		if (_value == kwargs.CompareTo)
		{
			if (kwargs.AddPercent) _value = _value + "%";
			return _value;
		}
	}

	// Returns 0.75 as red 25% and 1.75 as green 75%
	// Used to colorize mults which are applied to other values
	// Use case example: when someone has a 0.75 multiplier to their defense and you want to write "25% less defense" in tooltip
	function colorizeMult( _value, _kwargs = null )
	{
		local kwargs = {
			AddMoreLess = false,
			AddSign = false
		};

		if (_kwargs != null)
		{
			foreach (k, v in _kwargs)
			{
				if (k in kwargs)
				{
					kwargs[k] = v;
				}
			}
		}

		local addMoreLess = kwargs.AddMoreLess;
		delete kwargs.AddMoreLess;

		_kwargs.AddPercent <- true;

		local ret = this.colorizeValue(::Math.round((_value - 1.0) * 100), kwargs)

		if (addMoreLess)
		{
			if (("Invert" in kwargs) && kwargs.Invert)
				ret += _value < 1.0 ? " more" : " less";
			else
				ret += _value >= 1.0 ? " more" : " less";
		}

		return ret;
	}

	// Returns 0.75 as green 75% and 1.75 as green 175%, and -0.75 as red 75% and -1.75 as red 175%
	// Used when showing a certain percentage of another value
	// Use case example: when you want to say that you gain 25% of your hitpoints as stamina
	function colorizePct( _value, _kwargs = null )
	{
		if (_kwargs == null)
			_kwargs = {};
		if (!("AddSign" in _kwargs))
			_kwargs.AddSign <- false;

		_kwargs.AddPercent <- true;

		return this.colorizeValue(::Math.round(_value * 100), _kwargs);
	}
}
