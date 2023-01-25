::MSU.Class.SerializationModAddon <- class extends ::MSU.Class.SystemModAddon
{
	function isSavedVersionAtLeast( _version, _metaData )
	{
		local savedVersion = _metaData.getString(this.Mod.getID() + "Version");
		return savedVersion != "" && ::MSU.SemVer.compareVersionWithOperator(savedVersion, ">=", _version);
	}

	function flagSerialize( _id, _object, _flags = null )
	{
		::MSU.System.Serialization.flagSerialize(this.Mod, _id, _object, _flags);
	}

	function flagDeserialize( _id, _defaultValue, _object = null, _flags = null )
	{
		return ::MSU.System.Serialization.flagDeserialize(this.Mod, _id, _defaultValue, _object, _flags);
	}

	function getDeserializationEmulator( _id, _flags = null )
	{
		return ::MSU.System.Serialization.getDeserializationEmulator(this.Mod, _id, _flags);
	}

	function getSerializationEmulator( _id, _flags = null )
	{
		return ::MSU.System.Serialization.getSerializationEmulator(this.Mod, _id, _flags);
	}
}
