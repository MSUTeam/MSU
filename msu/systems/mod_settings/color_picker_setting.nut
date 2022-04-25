::MSU.Class.ColorPickerSetting <- class extends ::MSU.Class.AbstractSetting
{
	static Type = "ColorPicker";

	constructor( _id, _value,  _name = null )
	{
		_value = ::MSU.String.replace(_value, " ", "", true);
		base.constructor(_id, _value, _name);
	}

	function getValueAsTable()
	{
		local asArray = split(this.Value, ",");
		local asTable = {
			Red = asArray[0],
			Green = asArray[1],
			Blue = asArray[2],
			Alpha = asArray[3],
		};
		return asTable;
	}

	function getValueAsRGBA()
	{
		local asRGBA = "rgba(";
		local asTable = this.getValueAsTable();
		asRGBA += asTable.Red + ", ";
		asRGBA += asTable.Green + ", ";
		asRGBA += asTable.Blue + ", ";
		asRGBA += asTable.Alpha + ");";
		return asRGBA;
	}

	function getUIData()
	{
		local ret = base.getUIData();
		ret.values <- this.getValueAsTable();
		ret.valuesRGBA <- this.getValueAsRGBA();
		return ret;
	}

	function tostring()
	{
		local ret = base.tostring() + " | Values: \n";
		foreach (key, value in this.getValueAsTable())
		{
			ret += key + " : " +  value + "\n";
		}
		return ret;
	}
}
