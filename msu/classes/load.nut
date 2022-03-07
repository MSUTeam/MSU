this.MSU.Class <- {};

local function includeFile(_file)
{
	::includeFile("msu/classes/", _file);
}

includeFile("ordered_map.nut");
includeFile("weighted_container.nut");
