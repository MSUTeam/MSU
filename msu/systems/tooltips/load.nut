local function includeFile(_file)
{
	::includeFile("msu/systems/tooltips/", _file);
}

includeFile("tooltips_system");
::MSU.System.Tooltips <- ::MSU.Class.TooltipsSystem();
includeFile("tooltips_mod_addon");
includeFile("abstract_tooltip");
::includeFiles(::IO.enumerateFiles("msu/systems/tooltips/tooltips"));
