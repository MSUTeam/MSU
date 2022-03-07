this.MSU.System <- {};
this.MSU.SystemID <- {
	Serialization = 0,
	ModSettings = 1,
	ModRegistry = 2,
	Log = 3
}

local function includeLoad(_folder)
{
	::includeLoad("msu/systems/", _folder);
}

::includeFile("msu/systems/", "system.nut");

includeLoad("registry");
includeLoad("debug");
includeLoad("mod_settings");
includeLoad("serialization");

