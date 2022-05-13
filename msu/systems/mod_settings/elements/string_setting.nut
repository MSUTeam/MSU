::MSU.Class.StringSetting <- class extends ::MSU.Class.AbstractSetting
{
	static Type = "String";

	constructor( _id, _value, _name = null, _description = null )
	{
		::MSU.requireOneFromTypes(["string", "integer", "float"], _value);
		base.constructor(_id, _value, _name, _description);
	}

	function set( _value, _updateJS = true, _updatePersistence = true, _updateCallback = true, _force = true )
	{
		::MSU.requireString(_value);
		base.set(_value, _updateJS, _updatePersistence, _updateCallback, _force);
	}
}
