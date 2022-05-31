::MSU.Class.SerializationModAddon <- class extends ::MSU.Class.SystemModAddon
{
	function isSavedVersionAtLeast( _version, _metaData )
	{
		local savedVersion = _metaData.getString(this.Mod.getID() + "Version");
		return savedVersion != "" && ::MSU.SemVer.compareVersionWithOperator(savedVersion, ">=", _version);
	}

	function flagSerialize( _id, _object, _flags = null, _clear = true )
	{
		::MSU.System.Serialization.flagSerialize(this.Mod, _id, _object, _flags, _clear);
	}

	function flagDeserialize( _id, _object = null, _flags = null, _clear = true )
	{
		return ::MSU.System.Serialization.flagDeserialize(this.Mod, _id, _flags, _clear);
	}

	function flagSerializeBBObject( _id, _bbObject, _flags = null, _clear = true )
	{
		::MSU.System.Serialization.flagSerializeBBObject(this.Mod, _id, _bbObject, _flags, _clear);
	}

	function flagDeserializeBBObject( _id, _bbObject, _flags = null, _clear = true )
	{
		::MSU.System.Serialization.flagDeserializeBBObject(this.Mod, _id, _bbObject, _flags, _clear);
	}
}
