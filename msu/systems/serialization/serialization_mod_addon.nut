::MSU.Class.SerializationModAddon <- class extends ::MSU.Class.SystemModAddon
{
	function isSavedVersionAtLeast( _version, _metaData )
	{
		return _version == "" || ::MSU.System.Registry.compareVersionStrings(_metaData.getString(this.Mod.getID() + "Version"), _version) > -1;
	}
}
