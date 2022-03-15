::includeFile("msu/systems/serialization/", "serialization_system.nut");
this.MSU.System.Serialization <- this.MSU.Class.SerializationSystem();

::isSavedVersionAtLeast <- function( _modID, _version )
{
	return _version == "" || ::MSU.System.Registry.compareModToVersion(this.MSU.Mods[_modID], _version) > -1;
}

::MSU.Mod.register(::MSU.System.Serialization);
