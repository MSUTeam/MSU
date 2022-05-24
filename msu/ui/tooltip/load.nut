local function includeFile( _file )
{
	::includeFile("msu/ui/tooltip/", _file + ".nut");
}
includeFile("tooltip_setup");
includeFile("/classes/abstract_tooltip");
includeFile("/classes/ui_tooltip");
