::MSU.Class.SerializationModAddon <- class extends ::MSU.Class.SystemModAddon
{
	function isSavedVersionAtLeast( _version, _metaData )
	{
		local version = _metaData.getString(this.Mod.getID() + "Version")
		return version != "" && ::MSU.System.Registry.compareVersionStrings(version, _version) > -1;
	}
}
