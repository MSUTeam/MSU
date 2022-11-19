::MSU.Class.StringSetting <- class extends ::MSU.Class.AbstractSetting
{
	static Type = "String";

	constructor( _id, _value, _name = null, _description = null )
	{
		::MSU.requireOneFromTypes(["string", "integer", "float"], _value);
		base.constructor(_id, _value, _name, _description);
	}

	function set( _newValue, _kwargs = null)
	{
		::MSU.requireString(_newValue);
		::logInfo(base)
		::MSU.Log.printData(this, 1)
		return base.set(_newValue, _kwargs);
	}
}
