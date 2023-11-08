local function includeFile( _file )
{
	::MSU.includeFile("msu/msu_mod/", _file + ".nut");
}
includeFile("setup_msu_mod");
includeFile("msu_registry");
includeFile("msu_mod_debug");
includeFile("msu_mod_modsettings");
includeFile("msu_tooltips");
includeFile("msu_keybinds");
includeFile("nested_tooltips");
