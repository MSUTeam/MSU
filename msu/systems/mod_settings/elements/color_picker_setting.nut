::MSU.Class.ColorPickerSetting <- class extends ::MSU.Class.AbstractSetting
{
	static Type = "ColorPicker";

	constructor( _id, _value, _name = null, _description = null )
	{
		_value = ::MSU.String.replace(_value, " ", "", true);
		base.constructor(_id, _value, _name, _description);
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
		local asArray = split(this.Value, ",");
		asRGBA += asArray[0] + ", ";
		asRGBA += asArray[1] + ", ";
		asRGBA += asArray[2] + ", ";
		asRGBA += asArray[3] + ");";
		return asRGBA;
	}

	function getValueAsHexString()
	{
		local asArray = split(this.Value, ",");
		local red = format("%x", asArray[0].tointeger());
		if (asArray[0].tointeger() < 10) red = "0" + red;
		local green = format("%x", asArray[1].tointeger());
		if (asArray[1].tointeger() < 10) green = "0" + green;
		local blue = format("%x", asArray[2].tointeger());
		if (asArray[2].tointeger() < 10) blue = "0" + blue;
		local opacity = asArray[3] == "0.0" ? "00" : format("%x", (asArray[3].tofloat() * 255).tointeger());
		return  red + green + blue + opacity;
	}

	function getUIData( _flags = [] )
	{
		local ret = base.getUIData(_flags);
		ret.data.values <- this.getValueAsTable();
		ret.data.valuesRGBA <- this.getValueAsRGBA();
		return ret;
	}

	function tostring()
	{
		local ret = base.tostring() + " | Values: \n";
		foreach (key, value in this.getValueAsTable())
		{
			ret += key + " : " + value + "\n";
		}
		return ret;
	}
}
