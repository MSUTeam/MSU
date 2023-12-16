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
		::MSU.Class.U32SerializationData(this.len()).serialize(_out); // store length
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
}
