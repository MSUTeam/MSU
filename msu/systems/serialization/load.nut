this.MSU.Systems.Serialization <- this.MSU.Class.SerializationSystem();

::isSavedVersionAtLeast <- function( _modID, _version )
{
	return _version == "" || this.MSU.Mods[_modID].compareVersion(_version) > -1;
}