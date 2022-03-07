this.MSU.Class.BooleanSetting <- class extends this.MSU.Class.AbstractSetting
{
	static Type = "Boolean";

	constructor( _id, _value, _name = null)
	{
		if (typeof _value != "bool")
		{
			this.logError("The value for Boolean Setting must be a boolean");
			throw this.Exception.InvalidType;
		}
		base.constructor(_id, _value, _name);
	}

	function set( _value )
	{
		if (typeof _value != "bool")
		{
			this.logError("The value for Boolean Setting must be a boolean");
			throw this.Exception.InvalidType;
		}
		base.set(_value);
	}
}
