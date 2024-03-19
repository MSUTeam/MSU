::MSU.Class.SerializationData <- class extends ::MSU.Class.ArrayData
{
	constructor( _data = null )
	{
		if (_data == null)
			_data = [];
		base.constructor(_data);
		this.__Type = ::MSU.Serialization.DataType.SerializationData;
	}

	function getData()
	{
		return this;
	}

	function getDataRaw()
	{
		return this.__Data;
	}

	function push( _element )
	{
		this.__Data.push(_element);
		this.__DataArray.push(this.__convertValueFromBaseType(_element));
	}

	function getSerializationEmulator()
	{
		return ::MSU.Class.SerializationEmulator(::MSU.Class.MetaDataEmulator(), this);
	}

	function getDeserializationEmulator()
	{
		return ::MSU.Class.DeserializationEmulator(::MSU.Class.MetaDataEmulator(), this);
	}
}
