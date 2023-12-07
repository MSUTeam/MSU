::include("msu/systems/serialization/serialization_types/raw_data_array_data");
::MSU.Class.DataArrayData <- class extends ::MSU.Class.RawDataArrayData
{
	static __Type = ::MSU.Utils.SerializationDataType.DataArray;
	__MetaData = null;

	constructor()
	{
		base.constructor();
		this.__MetaData = clone ::MSU.System.Serialization.MetaData;
	}

	// overridden functions
	function deserialize( _in )
	{
		this.getMetaData().deserialize(_in);
		base.deserialize(_in);
	}

	function serialize( _out )
	{
		_out.writeU8(this.getType());
		this.getMetaData().serialize(_out);
		::MSU.Class.U32SerializationData(this.len()).serialize(_out); // store length
		for (local i = 0; i < this.__InnerArray.len(); ++i)
		{
			this.__InnerArray[i].serialize(_out);
		}
	}

	// new functions
	function getMetaData()
	{
		return this.__MetaData;
	}

	function setMetaData( _metaData )
	{
		this.__MetaData = _metaData;
	}

	function getElement( _idx )
	{
		return this.__InnerArray[_idx];
	}

	function createDeserializationEmulator( _metaData = null )
	{
		if (_metaData != null)
			this.setMetaData(_metaData);
		return ::MSU.Class.StrictDeserializationEmulator(this);
	}

	function createSerializationEmulator( _metaData = null )
	{
		if (_metaData != null)
			this.setMetaData(_metaData);
		return ::MSU.Class.StrictSerializationEmulator(this);
	}
}
