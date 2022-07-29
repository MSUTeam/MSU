// enulates the _in object passed to onDeserialize functions
::MSU.Class.DeserializationEmulator <- class extends ::MSU.Class.SerDeEmulator
{
	Idx = -1;

	function __readData()
	{
		if (this.Data.len() <= ++this.Idx)
		{
			::logError(format("Tried to read data beyond (%i) the length (%i) of the Deserialization Emulator", this.Idx, this.Data.len()));
			return null;
		}
		return this.Data[this.Idx];
	}

	function readString()
	{
		return this.__readData();
	}

	function __readInt()
	{
		return this.__readData();
	}

	function __readFloat()
	{
		return this.__readData();
	}

	function readBool()
	{
		return this.__readData();
	}

	function readI32()
	{
		return this.__readInt();
	}

	function readU32()
	{
		return this.__readInt();
	}

	function readI16()
	{
		return this.__readInt();
	}

	function readU16()
	{
		return this.__readInt();
	}

	function readI8()
	{
		return this.__readInt();
	}

	function readU8()
	{
		return this.__readInt();
	}

	function readF32()
	{
		return this.__readFloat();
	}

	function loadDataFromFlagContainer( _flags ) // doesn't check if flags exist
	{
		local startString = this.getEmulatorString();
		this.Data = array(_flags.get(startString));
		for (local i = 0; i < this.Data.len(); ++i)
		{
			if (_flags.has(startString + "." + i))
			{
				local value = _flags.get(startString + "." + i);
				this.Data[i] = value;
			}
		}
	}
}
