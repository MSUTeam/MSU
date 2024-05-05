::MSU.Class.SerializationData <- class extends ::MSU.Class.ArrayData
{
	MetaData = null;

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
		this.__DataArray.push(::MSU.Serialization.__convertValueFromBaseType(_element));
	}

	function write( _element, _type )
	{
		this.__Data.push(_element);
		this.__DataArray.push(::MSU.Serialization.__convertValueFromGivenType(_element, _type));
	}

	function getSerializationEmulator()
	{
		return ::MSU.Class.SerializationEmulator(::MSU.System.Serialization.getSerializationMetaData(), this);
	}

	function getDeserializationEmulator()
	{
		return ::MSU.Class.DeserializationEmulator(this.MetaData, this);
	}

	function serialize( _out )
	{
		base.serialize(_out);
		this.MetaData.serialize(_out);
	}

	function deserialize( _in )
	{
		base.deserialize(_in);
		this.MetaData = ::MSU.Class.MetaDataEmulator();
		this.MetaData.deserialize(_in);
	}
}
