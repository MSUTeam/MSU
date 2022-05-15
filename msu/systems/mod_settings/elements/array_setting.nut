::MSU.Class.ArraySetting <- class extends ::MSU.Class.AbstractSetting
{
	static Type = "Array";

	constructor( _id, _value, _name = null, _description = null, _lockLength = false)
	{
		::MSU.requireArray( _value);
		for (local i = 0; i < _value.len(); ++i)
		{
			::MSU.requireOneFromTypes(["string", "integer", "float", "array"], _value[i]);
			if (typeof _value[i] != "array")
			{
				_value[i] = [i, _value[i]]
			}
			else
			{
				if( _value[i].len() != 2) throw ::MSU.Exception.InvalidType(_value[i])
				::MSU.requireOneFromTypes(["string", "integer", "float"], _value[i][0]);
				::MSU.requireOneFromTypes(["string", "integer", "float"], _value[i][1]);
			}

		}
		base.constructor(_id, _value, _name, _description);
		this.lockLength(_lockLength);
	}

	function lockLength(_lockLength)
	{
		this.Data.lockLength <- _lockLength;
	}

	function tostring()
	{
		local ret = "Type: " + this.getType() + " | ID: " + this.getID() + " | Name: " + this.getName() + " | Values: \n"
		foreach (value in this.Value)
		{
			ret += (value[0] == null ? "null" : value[0]) + " : " +  value[1] + "\n";
		}
		return ret;
	}
}
