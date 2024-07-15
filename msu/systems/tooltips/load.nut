local function includeFile(_file)
{
	::MSU.includeFile("msu/systems/tooltips/", _file);
}

includeFile("abstract_tooltip");
includeFile("tooltips_system");
includeFile("tooltips_mod_addon");
::MSU.includeFiles(::IO.enumerateFiles("msu/systems/tooltips"));

::MSU.System.Tooltips <- ::MSU.Class.TooltipsSystem();
