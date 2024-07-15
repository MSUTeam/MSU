local function includeFile( _file )
{
	::MSU.includeFile("msu/msu_mod/", _file + ".nut");
}
includeFile("setup_msu_mod");
includeFile("msu_mod_debug");
::MSU.includeFiles(::IO.enumerateFiles("msu/msu_mod"));
