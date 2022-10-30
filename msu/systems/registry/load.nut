local function includeFile( _file )
{
	::includeFile("msu/systems/registry/", _file);
}
includeFile("registry_system");
includeFile("registry_mod_addon");

local system = ::MSU.Class.RegistrySystem();
::MSU.System.Registry <- system;

includeFile("mod_source");
includeFile("mod_source_github");
::MSU.System.Registry.addNewModSource(::MSU.Class.ModSourceGitHub);
includeFile("mod_source_nexusmods");
::MSU.System.Registry.addNewModSource(::MSU.Class.ModSourceNexusMods);

::MSU.getMod <- function( _modID )
{
	return ::MSU.System.Registry.getMod(_modID);
}

::MSU.hasMod <- function( _modID )
{
	return ::MSU.System.Registry.hasMod(_modID);
}
