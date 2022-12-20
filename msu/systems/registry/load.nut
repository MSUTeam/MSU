local function includeFile( _file )
{
	::MSU.includeFile("msu/systems/registry/", _file);
}
includeFile("registry_system");
includeFile("registry_mod_addon");

local system = ::MSU.Class.RegistrySystem();
::MSU.System.Registry <- system;

::includeFiles(::IO.enumerateFiles("msu/systems/registry/mod_sources"))

::MSU.System.Registry.addNewModSource(::MSU.Class.ModSourceGitHub);
::MSU.System.Registry.addNewModSource(::MSU.Class.ModSourceNexusMods);

::MSU.getMod <- function( _modID )
{
	return ::MSU.System.Registry.getMod(_modID);
}

::MSU.hasMod <- function( _modID )
{
	return ::MSU.System.Registry.hasMod(_modID);
}
