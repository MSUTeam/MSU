function includeFile( _file )
{
	::MSU.includeFile("msu/systems/keybinds/", _file + ".nut");
}

includeFile("key_static");
includeFile("abstract_keybind");
includeFile("keybinds_system");
includeFile("keybinds_mod_addon");
::MSU.includeFiles(::IO.enumerateFiles("msu/systems/keybinds"));

::MSU.System.Keybinds <- ::MSU.Class.KeybindsSystem();
::MSU.UI.addOnConnectCallback(::MSU.System.Keybinds.frameUpdate.bindenv(::MSU.System.Keybinds));
local clearEvents = ::Time.clearEvents;
::Time.clearEvents = function()
{
	clearEvents();
	::MSU.System.Keybinds.frameUpdate()
}
