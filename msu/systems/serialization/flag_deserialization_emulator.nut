// enulates the _in object passed to onDeserialize functions
::MSU.Class.FlagDeserializationEmulator <- class extends ::MSU.Class.FlagSerDeEmulator
{
	constructor( _mod, _id, _flagContainer, _metaDataEmulator = null )
	{
		if (_metaDataEmulator == null) // first check if we are currently deserializing
			_metaDataEmulator = ::MSU.System.Serialization.DeserializationMetaData;
		if (_metaDataEmulator == null) // if we are not, we default to the serialization meta data
			_metaDataEmulator = ::MSU.System.Serialization.SerializationMetaData;
		base.constructor(_mod, _id, _flagContainer, _metaDataEmulator);
	}

	function loadDataFromFlagContainer()
	{
		local startString = this.getEmulatorString();
		if (!this.FlagContainer.has(startString))
			return false;

		this.resetData();

		local len = this.FlagContainer.get(startString);
		this.FlagContainer.remove(startString);
		if (::MSU.Mod.Serialization.isSavedVersionAtLeast("1.4.0-a", this.MetaData))
		{
			for (local i = 0; i < len; i++)
			{
				local typeFlag = startString + "." + i + ".type";
				local dataFlag = startString + "." + i + ".data";
				if (!this.FlagContainer.has(typeFlag) || !this.FlagContainer.has(dataFlag))
					return false;

				local type = this.FlagContainer.get(typeFlag);
				local data = this.FlagContainer.get(dataFlag);

				this.SerializationData.write(data, type);

				this.FlagContainer.remove(typeFlag);
				this.FlagContainer.remove(dataFlag);
			}
		}
		else
		{
			for (local i = 0; i < len; ++i)
			{
				local currentFlag = startString + "." + i;
				if (!this.FlagContainer.has(currentFlag))
					return false;
				this.SerializationData.push(this.FlagContainer.get(currentFlag));
				this.FlagContainer.remove(currentFlag);
			}
		}

		return true;
	}
}

foreach (key, value in ::MSU.Class.SerDeEmulator.__ReadFields)
{
	::MSU.Class.FlagDeserializationEmulator[key] <- value;
}
