local function includeFile(_file)
{
	::MSU.includeFile("msu/systems/persistent_data/", _file);
}

includeFile("persistent_data_system");
includeFile("persistent_data_mod_addon");
::MSU.includeFiles(::IO.enumerateFiles("msu/systems/persistent_data"));

::MSU.System.PersistentData <- ::MSU.Class.PersistentDataSystem();
