::MSU.Class.SerializationDataCollection <- class
{
	// Any type of collection of primitive types.
	static __Type = ::MSU.System.Serialization.SerializationDataType.Collection;
	Collection = null;
	__Data = null;
	constructor(_data)
	{
		this.__Data = _data;
		this.Collection = [];
	}

	// must be called when overriden
	// Writes the type of the primitive object to be serialized, and then its data content
	function serialize( _out )
	{
		_out.writeU8(this.getType());
		::MSU.Class.PrimitiveSerializationData(::MSU.System.Serialization.SerializationDataType.U32, this.len()).serialize(_out); // store length
		for (local i = 0; i < this.Collection.len(); ++i)
		{
			this.Collection[i].serialize(_out);
		}
	}

	// must be called when overriden
	// First reads the type of the primitive, which is then initialised and deserialised in the serialisation system
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

	function getType()
	{
		return this.__Type;
	}

	function getData()
	{
		return this.__Data;
	}
}

