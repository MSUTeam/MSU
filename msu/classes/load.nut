::MSU.Class <- {};

local function includeFile(_file)
{
	::includeFile("msu/classes/", _file + ".nut");
}

includeFile("ordered_map");
includeFile("weighted_container");
