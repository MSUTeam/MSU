local function includeFile(_file)
{
	::MSU.includeFile("msu/systems/debug/", _file);
}

includeFile("debug_system");
includeFile("debug_mod_addon");
::MSU.includeFiles(::IO.enumerateFiles("msu/systems/debug"));

::MSU.System.Debug <- ::MSU.Class.DebugSystem();
