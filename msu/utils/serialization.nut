::MSU.Serialization <- {
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
		return ::MSU.Class.AbstractData.__readValueFromStorage(_in.readU8(), _in).getData()[0];
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
}
