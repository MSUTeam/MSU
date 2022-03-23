::MSU.Class.SerializationModAddon <- class extends ::MSU.Class.SystemModAddon
{
	function isSavedVersionAtLeast( _version, _metaData )
	{
		local savedVersion = _metaData.getString(this.Mod.getID() + "Version");
		return savedVersion != "" && ::MSU.System.Registry.compareVersionStrings(savedVersion, _version) > -1;
	}

	function serializeObject( _object, _out )
	{
		::MSU.System.Serialization.serializeObject(_object, _out);
	}

	function deserializeObject( _in )
	{
		::MSU.System.Serialization.deserializeObject(_in);
	}
}
