::MSU.Class.BooleanSetting <- class extends ::MSU.Class.AbstractSetting
{
	static Type = "Boolean";

	constructor( _id, _value, _name = null, _description = null )
	{
		::MSU.requireBool(_value);
		base.constructor(_id, _value, _name, _description);
	}

	function set( _value, _updateJS = true, _updatePersistence = true, _updateCallback = true, _force = true )
	{
		::MSU.requireBool(_value);
		base.set(_value, _updateJS, _updatePersistence, _updateCallback, _force);
	}
}
