function includeFile( _file )
{
	::includeFile("msu/systems/keybinds/", _file + ".nut");
}

includeFile("key_static");
includeFile("abstract_keybind");
includeFile("keybind_sq");
includeFile("keybind_js");
includeFile("keybinds_system");
::MSU.System.Keybinds <- ::MSU.Class.KeybindsSystem();
::MSU.UI.addOnConnectCallback(::MSU.System.Keybinds.frameUpdate.bindenv(::MSU.System.Keybinds));
local clearEvents = ::Time.clearEvents;
::Time.clearEvents = function()
{
	clearEvents();
	::MSU.System.Keybinds.frameUpdate()
}
includeFile("keybinds_mod_addon");

