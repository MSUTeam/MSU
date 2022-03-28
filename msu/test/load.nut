local function includeFile( _file )
{
	::includeFile("msu/test/", _file + ".nut");
}
if (::MSU.Mod.Debug.isEnabled("modsettings"))
{
	includeFile("mod_settings_system_test.nut");
}
