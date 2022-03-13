this.MSU.Class.BooleanSetting <- class extends this.MSU.Class.AbstractSetting
{
	static Type = "Boolean";

	constructor( _id, _value, _name = null)
	{
		::MSU.requireBool(_value)
		base.constructor(_id, _value, _name);
	}

	function set( _value, _updateJS = true, _updatePersistence = true, _updateCallback = true )
	{
		::MSU.requireBool(_value)
		base.set(_value, _updateJS, _updatePersistence, _updateCallback);
	}
}
