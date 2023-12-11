::MSU.Class.SerializationDataCollection <- class extends ::MSU.Class.AbstractSerializationData
{
	Collection = null;
	constructor(_data)
	{
		base.constructor(_data);
		this.Collection = [];
	}

	// must be called when overriden
	function serialize( _out )
	{
		base.serialize(_out);
		::MSU.Class.U32SerializationData(this.len()).serialize(_out); // store length
		for (local i = 0; i < this.Collection.len(); ++i)
		{
			this.Collection[i].serialize(_out);
		}
	}

	// must be called when overriden
	function deserialize( _in )
	{
		local type = _in.readU8();
		if (type != ::MSU.System.Serialization.SerializationDataType.U32)
			throw ::MSU.Exception.InvalidValue(type);
		local len = _in.readU32();
		this.Collection.resize(len)
		for (local i = 0; i < len; ++i)
		{
			this.Collection[i] = ::MSU.System.Serialization.readValueFromStorage(_in);
		}
	}

	function len()
	{
		return this.Collection.len();
	}
}

