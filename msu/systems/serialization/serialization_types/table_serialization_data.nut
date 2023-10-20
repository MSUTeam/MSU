::MSU.Class.TableSerializationData <- class extends ::MSU.Class.CustomSerializationData
{
	static __Type = ::MSU.Utils.SerializationDataType.Table;
	__DataArray = null;

	constructor( _data )
	{
		if (_data == null)
			_data = {};
		::MSU.requireTable(_data)
		base.constructor(_data);

		this.__DataArray = ::MSU.Class.RawDataArrayData();
		this.setLength(_data.len()*2);
		local i = 0;
		foreach (key, value in _data)
		{
			this.__DataArray.setElement(i++, this.__convertValueFromBaseType(key));
			this.__DataArray.setElement(i++, this.__convertValueFromBaseType(value));
		}
	}

	function setLength( _length )
	{
		this.__DataArray.setLength(_length);
	}

	function len()
	{
		return this.__DataArray.len();
	}

	function serialize( _out )
	{
		base.serialize(_out);
		this.__DataArray.serialize(_out);
	}

	function deserialize( _in )
	{
		base.deserialize(_in);
		_in.readU8(); // TODO
		this.__DataArray.deserialize(_in);
		local data = this.getData();
		for (local i = 0; i < this.__DataArray.len(); i+=2)
		{
			data[this.__DataArray.getElement(i).getData()] <- this.__DataArray.getElement(i+1).getData();
		}
	}
}
