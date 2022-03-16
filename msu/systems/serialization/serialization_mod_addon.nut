::MSU.Class.SerializationModAddon <- class extends ::MSU.Class.SystemModAddon
{
	function isSavedVersionAtLeast( _version )
	{
		return _version == "" || ::MSU.System.Registry.compareModToVersion(this.Mod, _version) > -1;
	}
}
