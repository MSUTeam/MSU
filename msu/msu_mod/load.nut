local function includeFile( _file )
{
	::includeFile("msu/msu_mod/", _file + ".nut");
}
includeFile("setup_msu_mod");
includeFile("msu_mod_debug");
includeFile("msu_mod_modsettings");
includeFile("msu_tooltips");
