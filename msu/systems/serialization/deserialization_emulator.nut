// enulates the _in object passed to onDeserialize functions
::MSU.Class.DeserializationEmulator <- class extends ::MSU.Class.FlagSerDeEmulator
{
	Idx = -1;

	function __readData( _type )
	{
		if (this.SerializationData.len() <= ++this.Idx)
		{
			::logError(format("Tried to read data beyond (%i) the length (%i) of the Deserialization Emulator", this.Idx, this.SerializationData.len()));
			return null;
		}
		local data = this.SerializationData.getDataArray()[this.Idx];
		if (data.getType() != _type)
		{
			::logError(format("The type being read %s isn't the same as the type %s stored in the Deserialization Emulator", ::MSU.Utils.SerializationDataType.getKeyForValue(_type), ::MSU.Utils.SerializationDataType.getKeyForValue(this.SerializationData.getDataArray()[this.Idx].getType())));
			// currently still continuing in case of conversion between integers
		}
		return data.getData();
	}

	function readString()
	{
		return this.__readData(::MSU.Utils.SerializationDataType.String);
	}

	function readBool()
	{
		return this.__readData(::MSU.Utils.SerializationDataType.Bool);
	}

	function readI32()
	{
		return this.__readData(::MSU.Utils.SerializationDataType.I32);
	}

	function readU32()
	{
		return this.__readData(::MSU.Utils.SerializationDataType.U32);
	}

	function readI16()
	{
		return this.__readData(::MSU.Utils.SerializationDataType.I16);
	}

	function readU16()
	{
		return this.__readData(::MSU.Utils.SerializationDataType.U16);
	}

	function readI8()
	{
		return this.__readData(::MSU.Utils.SerializationDataType.I8);
	}

	function readU8()
	{
		return this.__readData(::MSU.Utils.SerializationDataType.U8);
	}

	function readF32()
	{
		return this.__readData(::MSU.Utils.SerializationDataType.F32);
	}

	function loadDataFromFlagContainer()
	{
		local startString = this.getEmulatorString();
		if (!this.FlagContainer.has(startString))
			return false;

		this.resetData();

		local len = this.FlagContainer.get(startString);
		this.FlagContainer.remove(startString);
		for (local i = 0; i < len; ++i)
		{
			local currentFlag = startString + "." + i;
			if (!this.FlagContainer.has(currentFlag))
				return false;
			this.SerializationData.push(this.FlagContainer.get(currentFlag));
			this.FlagContainer.remove(currentFlag);
		}
		return true;
	}
}
