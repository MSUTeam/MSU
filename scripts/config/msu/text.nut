::MSU.Text <- {
	function color( _color, _string )
	{
		return format("[color=%s]%s[/color]", _color, _string);
	}

	function colorGreen( _string )
	{
		return this.color(::Const.UI.Color.PositiveValue, _string);
	}

	function colorRed( _string )
	{
		return this.color(::Const.UI.Color.NegativeValue, _string);
	}
}
