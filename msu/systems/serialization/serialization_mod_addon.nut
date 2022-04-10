::MSU.Class.SerializationModAddon <- class extends ::MSU.Class.SystemModAddon
{
	function isSavedVersionAtLeast( _version, _metaData )
	{
		local savedVersion = _metaData.getString(this.Mod.getID() + "Version");
		return savedVersion != "" && ::MSU.System.Registry.compareVersionStrings(savedVersion, _version) > -1;
	}
}
