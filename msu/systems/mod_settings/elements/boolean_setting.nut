::MSU.Class.BooleanSetting <- class extends ::MSU.Class.AbstractSetting
{
	static Type = "Boolean";

	constructor( _id, _value, _name = null, _description = null )
	{
		::MSU.requireBool(_value);
		base.constructor(_id, _value, _name, _description);
	}

	function set( _newValue, _updateJS = true, _updatePersistence = true, _updateBeforeChangeCallback = true, _force = true, _updateAfterChangeCallback = true)
	{
		::MSU.requireBool(_newValue);
		return base.set(_newValue, _updateJS, _updatePersistence, _updateBeforeChangeCallback, _force, _updateAfterChangeCallback);
	}
}
