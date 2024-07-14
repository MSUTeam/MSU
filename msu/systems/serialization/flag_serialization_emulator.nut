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
			this.FlagContainer.set(startString + ".type." + (this.SerializationData.len() - 1), _type);
			this.FlagContainer.set(startString + ".data." + (this.SerializationData.len() - 1), _data);
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
			this.FlagContainer.set(startString + ".type." + i, element.getType());
			this.FlagContainer.set(startString + ".data." + i, element.getData());
		}
	}
}

foreach (key, value in ::MSU.Class.SerDeEmulator.__WriteFields)
{
	::MSU.Class.FlagSerializationEmulator[key] <- value;
}
