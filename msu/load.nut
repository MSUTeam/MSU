local function includeLoad( _folder )
{
	::MSU.includeLoad("msu/", _folder);
}

// utils and classes are loaded before mods_queue in scripts/config/!msu.nut

includeLoad("ui");
includeLoad("systems");
includeLoad("hooks");
includeLoad("msu_mod");
includeLoad("vanilla_mod");
includeLoad("test");

this.Const.World.RoadBrushes.add(::Const.Direction.N, "road_N");
this.Const.World.RoadBrushes.add(::Const.Direction.S, "road_S"); // idk where to put these
