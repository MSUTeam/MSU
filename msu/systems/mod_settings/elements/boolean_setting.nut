::MSU.Class.BooleanSetting <- class extends ::MSU.Class.AbstractSetting
{
	static Type = "Boolean";

	constructor( _id, _value, _name = null, _description = null )
	{
		::MSU.requireBool(_value);
		base.constructor(_id, _value, _name, _description);
	}

	function set( _newValue, _kwargs = null)
	{
		::MSU.requireBool(_newValue);
		return base.set(_newValue, _kwargs);
	}
}
