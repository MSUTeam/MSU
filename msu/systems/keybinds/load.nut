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
includeFile("keybinds_mod_addon");

