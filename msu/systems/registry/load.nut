local function includeFile( _file )
{
	::includeFile("msu/systems/registry/", _file);
}
includeFile("registry_system.nut");

local system = ::MSU.Class.RegistrySystem();

::MSU.System.Registry <- system;

::MSU.getMod <- function( _modID )
{
	return ::MSU.System.Registry.getMod(_modID);
}

::MSU.hasMod <- function( _modID )
{
	return ::MSU.System.Registry.hasMod(_modID);
}
