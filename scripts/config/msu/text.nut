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
}
