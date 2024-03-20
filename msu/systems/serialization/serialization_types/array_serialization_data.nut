::MSU.Class.ArrayData <- class extends ::MSU.Class.AbstractData
{
	__DataArray = null;

	constructor( _data )
	{
		::MSU.requireArray(_data);

		base.constructor(::MSU.Serialization.DataType.Array, _data);

		this.__DataArray = array(_data.len());
		foreach (i, value in _data)
		{
			this.__DataArray[i] = ::MSU.Serialization.__convertValueFromBaseType(value);
		}
	}

	function len()
	{
		return this.__Data.len();
	}

	function getDataArray()
	{
		return this.__DataArray;
	}

	function serialize( _out )
	{
		base.serialize(_out);
		// Necessary to do it this way instead of simply _out.writeU32 because during deserialization in
		// flag_deserialization_emulator the length is pushed to SerializationData which then converts
		// it using __convertValueFromBaseType which may end up being a U8 for example. This then would
		// throw a warning in the log when trying to read it as a U32. To prevent this, we serialize it
		// by already converting it to the appropriate type here.
		::MSU.Serialization.__convertValueFromBaseType(this.__DataArray.len()).serialize(_out);
		foreach (value in this.__DataArray)
		{
			value.serialize(_out);
		}
	}

	function deserialize( _in )
	{
		local len = ::MSU.Serialization.__readValueFromStorage(_in.readU8(), _in).getData();
		this.__Data = array(len);
		this.__DataArray = array(len);
		for (local i = 0; i < len; i++)
		{
			local value = ::MSU.Serialization.__readValueFromStorage(_in.readU8(), _in);
			this.__DataArray[i] = value;
			this.__Data[i] = value.getData();
		}
	}
}
