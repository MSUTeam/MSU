// If want to do a more complex thing where environment is immportant for structure
{
	ID = "xyz",
	Name = "XYZ",
	Icon = null, //optional
	function getTooltip(_environment = null)
	{

	}
}

// If want to do something simmple where environment will not change the structure of the tooltip
{
	ID = "xyz",
	Name = "XYZ",
	Icon = null, //optional
	Text = ""

	function getVars(_environment = null) // optional
	{
		
	}
}
