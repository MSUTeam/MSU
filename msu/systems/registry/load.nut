local function includeFile( _file )
{
	::includeFile("msu/systems/registry/", _file);
}
includeFile("registry_system.nut");

local system = ::MSU.Class.RegistrySystem();

::MSU.System.Registry <- system;
::MSU.Mods <- system.Mods;
::MSU.getMod <- function( _modID )
{
	if(!(_modID in this.Mods))
	{
		throw ::MSU.Exception.KeyNotFound;
	}
	return this.Mods[_modID];
}
