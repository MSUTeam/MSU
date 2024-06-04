::MSU.Serialization.Class.SerializationData <- class extends ::MSU.Serialization.Class.ArrayData
{
	__MetaData = null;

	constructor( _data = null )
	{
		if (_data == null)
			_data = [];
		base.constructor(_data);
		this.__Type = ::MSU.Serialization.DataType.SerializationData;
		this.__MetaData = ::MSU.Class.MetaDataEmulator();
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
		this.__DataArray.push(::MSU.Serialization.__convertValueFromBaseType(_element));
	}

	function write( _element, _type )
	{
		this.__Data.push(_element);
		this.__DataArray.push(::MSU.Serialization.__convertValueFromGivenType(_element, _type));
	}

	function serialize( _out )
	{
		this.__MetaData.setRealMeta(::MSU.System.Serialization.SerializationMetaData);
		base.serialize(_out);
		this.__MetaData.serialize(_out);
	}

	function deserialize( _in )
	{
		this.__MetaData = ::MSU.Class.MetaDataEmulator();
		base.deserialize(_in);
		this.__MetaData.deserialize(_in);
	}

	function getSerializationEmulator()
	{
		this.__MetaData.setRealMeta(::MSU.System.Serialization.SerializationMetaData);
		return ::MSU.Class.SerializationEmulator(this.__MetaData, this);
	}

	function getDeserializationEmulator()
	{
		return ::MSU.Class.DeserializationEmulator(this.__MetaData, this);
	}
}
