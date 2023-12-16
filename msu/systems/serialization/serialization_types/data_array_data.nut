::MSU.Class.DataArrayData <- class extends ::MSU.Class.SerializationDataCollection
{
	static __Type = ::MSU.System.Serialization.SerializationDataType.DataArray;
	__MetaData = null;

	constructor(_data = null)
	{
		base.constructor(_data);
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
		::MSU.Class.PrimitiveSerializationData(::MSU.System.Serialization.SerializationDataType.U32, this.len()).serialize(_out); // store length
		for (local i = 0; i < this.Collection.len(); ++i)
		{
			this.Collection[i].serialize(_out);
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

	function writeFrom(_obj)
	{
		_obj.onSerialize(this.createSerializationEmulator());
	}
	function writeTo(_obj)
	{
		_obj.onDeserialize(this.createDeserializationEmulator());
	}
}
