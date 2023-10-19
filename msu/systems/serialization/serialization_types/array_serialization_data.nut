::MSU.Class.ArraySerializationData <- class extends ::MSU.Class.CustomSerializationData
{
	static __Type = ::MSU.Utils.SerializationDataType.Array;
	__DataArray = null;

	constructor( _data )
	{
		if (_data == null)
			_data = [];
		::MSU.requireArray(_data);
		base.constructor(_data);

		this.__DataArray = ::MSU.Class.DataArrayData();
		this.setLength(_data.len());

		foreach (i, element in _data)
		{
			this.__DataArray.setElement(i, this.__convertValueFromBaseType(element));
		}
	}

	function setLength( _length )
	{
		this.getData().resize(_length);
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
		_in.readU8();
		this.__DataArray.deserialize(_in);
		local data = this.getData();
		for (local i = 0; i < this.len(); ++i)
		{
			data[i] = this.__DataArray.getElement(i).getData()
		}
	}
}
