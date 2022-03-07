local function includeFile( _file )
{
	::includeFile("msu/systems/registry/", _file);
}
includeFile("mod.nut");
includeFile("registry_system.nut");

local system = this.MSU.Class.ModRegistrySystem();

this.MSU.System.ModRegistry <- system;
this.MSU.Mods <- system.Mods;
this.MSU.registerMod <- system.registerMod;

this.MSU.registerMod(this.MSU.ID, this.MSU.Version, this.MSU.Name);
