local function includeFile( _file )
{
	::includeFile("msu/systems/registry/", _file);
}
includeFile("mod.nut");
includeFile("registry_system.nut");

local system = this.MSU.Class.RegistrySystem();

this.MSU.System.Registry <- system;
this.MSU.Mods <- system.Mods;
this.MSU.registerMod <- system.registerMod.bindenv(system);

this.MSU.System.Registry.addMod(this.MSU.VanillaID, "1.4.0-48", "Vanilla")
this.MSU.registerMod(this.MSU.ID, this.MSU.Version, this.MSU.Name);

