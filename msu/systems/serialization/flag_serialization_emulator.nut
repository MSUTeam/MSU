// enulates the _out object passed to onSerialize functions
::MSU.Class.FlagSerializationEmulator <- class extends ::MSU.Class.FlagSerDeEmulator
{
	IsIncremental = false;

	function setIncremental( _bool )
	{
		this.IsIncremental = _bool;
	}

	function __writeData( _data )
	{
		base.__writeData(_data);
		if (this.IsIncremental)
		{
			local startString = this.getEmulatorString();
			this.FlagContainer.set(startString, this.SerializationData.len());
			this.FlagContainer.set(startString + "." + (this.SerializationData.len() - 1), _data);
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
		foreach (idx, element in this.SerializationData.getDataRaw())
		{
			this.FlagContainer.set(startString + "." + idx, element);
		}
	}
}
