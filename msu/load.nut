local function includeLoad( _folder )
{
	::MSU.includeLoad("msu/", _folder);
}

// utils and classes are loaded before mods_queue in scripts/config/!msu.nut

includeLoad("ui");
includeLoad("systems");
includeLoad("hooks_helper");
includeLoad("hooks");
includeLoad("msu_mod");
includeLoad("vanilla_mod");
includeLoad("test");

delete ::MSU.HooksHelper;
