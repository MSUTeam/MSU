// emulates the _in object passed to onDeserialize functions
::MSU.Class.StrictDeserializationEmulator <- class extends ::MSU.Class.StrictSerDeEmulator
{
	Idx = -1;

	function __readData(_type)
	{
		local collectionLen = this.getDataArray().Collection.len();
		if (collectionLen <= ++this.Idx)
		{
			::logError(format("Tried to read data beyond (%i) the length (%i) of the Deserialization Emulator", this.Idx, collectionLen));
			return null;
		}
		local serialization_pair = this.getDataArray().Collection[this.Idx];
		if (serialization_pair.getType() != _type)
		{
			::logError(format("The type being read %s isn't the same as the type %s stored in the Deserialization Emulator", ::MSU.System.Serialization.SerializationDataType.getKeyForValue(_type), ::MSU.System.Serialization.SerializationDataType.getKeyForValue(this.Data[this.Idx].getType())));
			// currently still continuing in case of conversion between integers
		}
		return serialization_pair.getData();
	}

	function readString()
	{
		return this.__readData(::MSU.System.Serialization.SerializationDataType.String);
	}

	function readBool()
	{
		return this.__readData(::MSU.System.Serialization.SerializationDataType.Bool);
	}

	function readI32()
	{
		return this.__readData(::MSU.System.Serialization.SerializationDataType.I32);
	}

	function readU32()
	{
		return this.__readData(::MSU.System.Serialization.SerializationDataType.U32);
	}

	function readI16()
	{
		return this.__readData(::MSU.System.Serialization.SerializationDataType.I16);
	}

	function readU16()
	{
		return this.__readData(::MSU.System.Serialization.SerializationDataType.U16);
	}

	function readI8()
	{
		return this.__readData(::MSU.System.Serialization.SerializationDataType.I8);
	}

	function readU8()
	{
		return this.__readData(::MSU.System.Serialization.SerializationDataType.U8);
	}

	function readF32()
	{
		return this.__readData(::MSU.System.Serialization.SerializationDataType.F32);
	}
}
