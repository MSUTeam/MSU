local function includeLoad( _folder )
{
	::MSU.includeLoad("msu/", _folder);
}

includeLoad("ui");
includeLoad("systems");
includeLoad("hooks");
includeLoad("msu_mod");
includeLoad("vanilla_mod");
includeLoad("test");
