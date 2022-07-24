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

	function flagDeserialize( _id, _object = null, _flags = null )
	{
		return ::MSU.System.Serialization.flagDeserialize(this.Mod, _id, _object, _flags);
	}

	function flagSerializeBBObject( _id, _bbObject, _flags = null )
	{
		::MSU.System.Serialization.flagSerializeBBObject(this.Mod, _id, _bbObject, _flags);
	}

	function flagDeserializeBBObject( _id, _bbObject, _flags = null )
	{
		::MSU.System.Serialization.flagDeserializeBBObject(this.Mod, _id, _bbObject, _flags);
	}
}
