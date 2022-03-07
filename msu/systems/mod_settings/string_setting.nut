this.MSU.Class.StringSetting <- class extends this.MSU.Class.AbstractSetting
{
	static Type = "String";

	constructor( _id, _value, _name = null)
	{
		if (typeof _value != "string")
		{
			this.logError("The value for String Setting must be a string");
			throw this.Exception.InvalidType;
		}
		base.constructor(_id, _value, _name);
	}

	function set( _value )
	{
		if (typeof _value != "string")
		{
			this.logError("The value for String Setting must be a string");
			throw this.Exception.InvalidType;
		}
		base.set(_value);
	}
}
