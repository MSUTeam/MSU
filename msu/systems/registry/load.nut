local function includeFile( _file )
{
	::includeFile("msu/systems/registry/", _file);
}
includeFile("registry_system.nut");

local system = this.MSU.Class.RegistrySystem();

this.MSU.System.Registry <- system;
this.MSU.Mods <- system.Mods;
