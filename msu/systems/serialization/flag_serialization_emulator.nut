// enulates the _out object passed to onSerialize functions
::MSU.Class.FlagSerializationEmulator <- class extends ::MSU.Class.FlagSerDeEmulator
{
	IsIncremental = false;

	constructor( _mod, _id, _flagContainer, _metaDataEmulator = null )
	{
		base.constructor(_mod, _id, _flagContainer, _metaDataEmulator != null ? _metaDataEmulator : ::MSU.System.Serialization.SerializationMetaData);
	}

	function setIncremental( _bool )
	{
		this.IsIncremental = _bool;
	}

	function __writeData( _data, _type )
	{
		base.__writeData(_data, _type);
		if (this.IsIncremental)
		{
			local startString = this.getEmulatorString();
			this.FlagContainer.set(startString, this.SerializationData.len());
			local prefix = startString + "." + (this.SerializationData.len() - 1);
			this.__storeTypeInFlagContainer(prefix, _type);
			this.FlagContainer.set(prefix + ".data", _data);
		}
	}

	function __storeTypeInFlagContainer( _prefix, _type )
	{
		switch (_type)
		{
			case ::MSU.Serialization.DataType.U8: case ::MSU.Serialization.DataType.U16: case ::MSU.Serialization.DataType.U32:
			case ::MSU.Serialization.DataType.I8: case ::MSU.Serialization.DataType.I16: case ::MSU.Serialization.DataType.I32:
			case ::MSU.Serialization.DataType.F32:
				this.FlagContainer.set(_prefix + ".type", _type);
				break;
		}
	}

	function storeDataInFlagContainer()
	{
		if (this.IsIncremental)
		{
			::logError("Called storeDataInFlagContainer for an Incremental SerializationEmulator");
			throw ::MSU.Exception.InvalidValue();
		}
		local startString = this.getEmulatorString();
		this.FlagContainer.set(startString, this.SerializationData.len());
		foreach (i, element in this.SerializationData.getDataArray())
		{
			local prefix = startString + "." + i;
			this.__storeTypeInFlagContainer(prefix, element.getType());
			this.FlagContainer.set(prefix + ".data", element.getData());
		}
	}
}

foreach (key, value in ::MSU.Class.SerDeEmulator.__WriteFields)
{
	::MSU.Class.FlagSerializationEmulator[key] <- value;
}
