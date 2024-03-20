::MSU.Class.ArrayData <- class extends ::MSU.Class.AbstractData
{
	__DataArray = null;

	constructor( _data )
	{
		::MSU.requireArray(_data);

		base.constructor(::MSU.Utils.SerializationDataType.Array, _data);

		this.__DataArray = array(_data.len());
		foreach (i, value in _data)
		{
			this.__DataArray[i] = this.__convertValueFromBaseType(value);
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
		_out.writeU32(this.__DataArray.len());
		foreach (value in this.__DataArray)
		{
			value.serialize(_out);
		}
	}

	function deserialize( _in )
	{
		local len = _in.readU32();
		this.__Data = array(len);
		this.__DataArray = array(len);
		for (local i = 0; i < len; i++)
		{
			local value = this.__readValueFromStorage(_in.readU8(), _in);
			this.__DataArray[i] = value;
			this.__Data[i] = value.getData();
		}
	}
}
