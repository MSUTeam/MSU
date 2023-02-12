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
}
