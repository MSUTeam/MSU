::MSU.Class.ColorPickerSetting <- class extends ::MSU.Class.AbstractSetting
{
	ValuesAsTable = null;
	ValuesAsRGBA = null;
	static Type = "ColorPicker";

	constructor( _id, _value,  _name = null )
	{
		base.constructor(_id, _value, _name);
		this.convertValue();
	}

	function turnValueIntoTable()
	{
		local asArray = split(this.Value, ",");
		this.ValuesAsTable = {
			Red = asArray[0],
			Green = asArray[1],
			Blue = asArray[2],
			Alpha = asArray[3],
		};
	}

	function turnValueIntoRGBA()
	{
		local asRGBA = "rgba(";
		asRGBA += this.ValuesAsTable.Red + ", ";
		asRGBA += this.ValuesAsTable.Green + ", ";
		asRGBA += this.ValuesAsTable.Blue + ", ";
		asRGBA += this.ValuesAsTable.Alpha + ");";
		this.ValuesAsRGBA = asRGBA;
	}

	function convertValue()
	{
		this.turnValueIntoTable();
		this.turnValueIntoRGBA();
	}

	function getUIData()
	{
		local ret = base.getUIData();
		ret.values <- this.ValuesAsTable;
		ret.valuesRGBA <- this.ValuesAsRGBA;
		return ret;
	}

	function tostring()
	{
		local ret = base.tostring() + " | Values: \n";
		foreach (key, value in this.ValuesAsTable)
		{
			ret += key + " : " +  value + "\n";
		}
		return ret;
	}

	function set( _value, _updateJS = true, _updatePersistence = true, _updateCallback = true )
	{
		base.set(_value, _updateJS, _updatePersistence, _updateCallback);
		this.convertValue();
	}

	function flagDeserialize()
	{
		base.flagDeserialize();
		this.convertValue();
	}

	//Note the Array ISN'T serialized
}
