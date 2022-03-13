this.MSU.Class.KeybindSetting <- class extends this.MSU.Class.StringSetting
{
	static Type = "Keybind";

	constructor( _id, _value, _name = null)
	{
		::MSU.requireString(_value);
		base.constructor(_id, _value, _name);
	}

	function set( _value, _updateJS = true, _updatePersistence = true, _updateCallback = true )
	{
		::MSU.requireString(_value);
		base.set(_value, _updateJS, _updatePersistence, _updateCallback);
	}
}
