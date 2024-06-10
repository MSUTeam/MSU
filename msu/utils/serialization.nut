::MSU.Serialization <- {
	Class = {},
	DataType = ::MSU.Class.Enum([
		"None",
		"Unknown",
		"Null",
		"Bool",
		"String",
		"U8",
		"U16",
		"U32",
		"I8",
		"I16",
		"I32",
		"F32",
		"Table",
		"Array",
		"SerializationData"
	]),

	function serialize( _object, _out )
	{
		::MSU.Class.ArrayData([_object]).serialize(_out);
	}

	function deserialize( _in )
	{
		return this.__readValueFromStorage(_in.readU8(), _in).getData()[0];
	}

	function deserializeInto( _object, _in )
	{
		::MSU.requireOneFromTypes(["table", "array"], _object);

		local deserializedObj = this.deserialize(_in);

		if (typeof _object == "table")
			return ::MSU.Table.merge(_object, deserializedObj);

		_object.resize(::Math.max(_object.len(), deserializedObj.len()));
		foreach (i, value in deserializedObj)
		{
			_object[i] = value;
		}
		return _object;
	}

	function __readValueFromStorage( _type, _in )
	{
		switch (_type)
		{
			case this.DataType.U8: case this.DataType.U16: case this.DataType.U32:
			case this.DataType.I8: case this.DataType.I16: case this.DataType.I32:
			case this.DataType.F32: case this.DataType.Bool: case this.DataType.String:
				return ::MSU.Class.PrimitiveData(_type, _in["read" + this.DataType.getKeyForValue(_type)]());

			case this.DataType.Table:
				local ret = ::MSU.Class.TableData({});
				ret.deserialize(_in);
				return ret;

			case this.DataType.Array:
				local ret = ::MSU.Class.ArrayData([]);
				ret.deserialize(_in);
				return ret;

			case this.DataType.SerializationData:
				local ret = ::MSU.Class.SerializationData([]);
				ret.deserialize(_in);
				return ret;

			case this.DataType.Null:
				return ::MSU.Class.PrimitiveData(this.DataType.Null, null);

			default:
				::logError("Attempted to deserialize unknown type");
				throw ::MSU.Exception.InvalidValue(_type);
		}
	}

	function __convertValueFromBaseType( _value )
	{
		switch (typeof _value)
		{
			case "integer":
				if (_value >= 0)
				{
					if (_value <= 255)
						return ::MSU.Class.PrimitiveData(this.DataType.U8, _value);
					else if (_value <= 65535)
						return ::MSU.Class.PrimitiveData(this.DataType.U16, _value);
					else
						return ::MSU.Class.PrimitiveData(this.DataType.U32, _value);
				}
				else
				{
					if (_value >= -128)
						return ::MSU.Class.PrimitiveData(this.DataType.I8, _value);
					else if  (_value >= -32768)
						return ::MSU.Class.PrimitiveData(this.DataType.I16, _value);
					else
						return ::MSU.Class.PrimitiveData(this.DataType.I32, _value);
				}
				break;
			case "string":
				return ::MSU.Class.PrimitiveData(this.DataType.String, _value);
			case "float":
				return ::MSU.Class.PrimitiveData(this.DataType.F32, _value);
			case "bool":
				return ::MSU.Class.PrimitiveData(this.DataType.Bool, _value);
			case "null":
				return ::MSU.Class.PrimitiveData(this.DataType.Null, null);
			case "table":
				if (::MSU.isBBObject(_value))
				{
					::logError("MSU Serialization cannot serialize BB Objects directly");
					throw ::MSU.Exception.InvalidValue(_value);
				}
				return ::MSU.Class.TableData(_value);
			case "array":
				return ::MSU.Class.ArrayData(_value);
			case "instance":
				if (_value instanceof ::MSU.Class.SerializationData)
					return _value;
				if (_value instanceof ::MSU.Class.SerDeEmulator)
					return _value.getData();

				::logError("MSU Serialization cannot handle instances other than descendants of ::MSU.Class.AbstractData");
				throw ::MSU.Exception.InvalidValue(_value);

			default:
				::logError("Attempted to serialize unknown type");
				throw ::MSU.Exception.InvalidType(_value);
		}
	}

	function __convertValueFromGivenType( _value, _type )
	{
		switch (_type)
		{
			case this.DataType.U8: case this.DataType.U16: case this.DataType.U32:
			case this.DataType.I8: case this.DataType.I16: case this.DataType.I32:
			case this.DataType.F32: case this.DataType.Bool: case this.DataType.String:
			case this.DataType.Null:
				return ::MSU.Class.PrimitiveData(_type, _value);

			case this.DataType.Table:
				return ::MSU.Class.TableData(_value);

			case this.DataType.Array:
				return ::MSU.Class.ArrayData(_value);

			case this.DataType.SerializationData:
				return ::MSU.Class.SerializationData(_value);

			default:
				::logError("Attempted to convert unknown type");
				throw ::MSU.Exception.InvalidValue(_type);
		}
	}
}
