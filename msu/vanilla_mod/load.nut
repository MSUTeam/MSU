local function includeFile( _file )
{
	::MSU.includeFile("msu/vanilla_mod/", _file + ".nut");
}
includeFile("setup_vanilla_mod");
::MSU.includeFiles(::IO.enumerateFiles("msu/vanilla_mod"));


