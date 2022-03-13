function includeFile( _file )
{
	::includeFile("msu/systems/keybinds/", _file + ".nut");
}

includeFile("key_static");
includeFile("keybind");
includeFile("keybind_sq");
includeFile("keybind_js");
includeFile("keybinds_system");

::MSU.System.Keybinds <- ::MSU.Class.KeybindsSystem();

includeFile("vanilla_keybinds");
