::MSU.Class.PrimitiveData <- class extends ::MSU.Class.AbstractData
{
	constructor( _type, _data )
	{
		switch( _type )
		{
			case ::MSU.Serialization.DataType.U8:
				if (typeof _data != "integer" || _data < 0 || _data > 255)
					this.__printInvalidDataError(_type, _data);
				break;

			case ::MSU.Serialization.DataType.U16:
				if (typeof _data != "integer" || _data < 0 || _data > 65535)
					this.__printInvalidDataError(_type, _data);
				break;

			case ::MSU.Serialization.DataType.U32:
				if (typeof _data != "integer" || _data < 0)
					this.__printInvalidDataError(_type, _data);
				break;

			case ::MSU.Serialization.DataType.I8:
				if (typeof _data != "integer" || _data < -128 || _data > 127)
					this.__printInvalidDataError(_type, _data);
				break;

			case ::MSU.Serialization.DataType.I16:
				if (typeof _data != "integer" || _data < -32768 || _data > 32767)
					this.__printInvalidDataError(_type, _data);
				break;

			case ::MSU.Serialization.DataType.I32:
				if (typeof _data != "integer")
					this.__printInvalidDataError(_type, _data);
				break;

			case ::MSU.Serialization.DataType.F32:
				if (typeof _data != "float" && typeof _data != "integer")
					this.__printInvalidDataError(_type, _data);
				break;

			case ::MSU.Serialization.DataType.Bool:
				if (typeof _data != "bool")
					this.__printInvalidDataError(_type, _data);
				break;

			case ::MSU.Serialization.DataType.String:
				if (typeof _data != "string")
					this.__printInvalidDataError(_type, _data);
				break;

			case ::MSU.Serialization.DataType.Null:
				if (_data != null)
					this.__printInvalidDataError(_type, _data);
				break;

			default:
				throw ::MSU.Exception.InvalidValue(_type);
		}

		base.constructor(_type, _data);
	}

	function isTypeValid( _type )
	{
		if (base.isTypeValid(_type))
			return true;

		// Allows vanilla skill.nut deserialiation of this.m.IsNew to work. Shouldn't be documented.
		return _type == ::MSU.Serialization.DataType.U8 && this.__Type == ::MSU.Serialization.DataType.Bool;
	}

	function serialize( _out )
	{
		base.serialize(_out);
		if (this.getType() != ::MSU.Serialization.DataType.Null)
			_out["write" + ::MSU.Serialization.DataType.getKeyForValue(this.getType())](this.getData());
	}

	function deserialize( _in )
	{
		if (this.getType() != ::MSU.Serialization.DataType.Null)
			this.__Data = _in["read" + ::MSU.Serialization.DataType.getKeyForValue(this.getType())]();
	}

	function __printInvalidDataError( _type, _data )
	{
		::logError(format("Storing invalid or unexpected data \'%s\' in container of type: %s", _data + "", ::MSU.Serialization.DataType.getKeyForValue(_type)));
		// We have to print the full stack trace here because we cannot know for sure which level of stackinfos will be the actual source of the problem
		// as it will be different if this is being instantiated by someone in their own function somewhere or if it is being instantiated
		// by MSU functions e.g. ::MSU.Serialization.__convertValueFromBaseType
		::MSU.Log.printStackTrace();
	}
}
