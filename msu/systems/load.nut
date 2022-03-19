::MSU.System <- {};
::MSU.SystemID <- {
	Serialization = 0,
	ModSettings = 1,
	Registry = 2,
	Log = 3,
	Keybinds = 4
};

local function includeLoad( _folder )
{
	::includeLoad("msu/systems/", _folder);
}

local function includeFile( _file )
{
	::includeFile("msu/systems/", _file + ".nut")
}

includeFile("system");
includeFile("system_mod_addon");
includeFile("empty_mod_addon");
::MSU.EmptyModAddon <- ::MSU.Class.EmptyModAddon();
includeLoad("registry");
includeLoad("debug");

includeFile("mod");
::MSU.Vanilla <- ::MSU.Class.Mod(::MSU.VanillaID, ::MSU.System.Registry.formatVanillaVersionString(::GameInfo.getVersionNumber()), "Vanilla");
::MSU.Mod <- ::MSU.Class.Mod(::MSU.ID, ::MSU.Version, ::MSU.Name)

::MSU.Mod.register(::MSU.System.Debug, true);
//need to set this first to print the others
::MSU.Mod.Debug.setFlag("debug", true);
::MSU.Mod.Debug.setFlags({
	"movement" : false,
	"skills" : false,
	"keybinds" : true,
	"persistence" : true
})
::MSU.Vanilla.register(::MSU.System.Debug, true);

includeLoad("mod_settings");
includeLoad("serialization");
includeLoad("keybinds");
