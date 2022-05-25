::includeLoad <- function( _prefix, _folder )
{
	::include(_prefix + _folder + "/load.nut");
}
::includeFile <- function( _prefix, _file )
{
	::include(_prefix + _file);
}
::includeFiles <- function( _files, _includeLoad = false )
{
	foreach (file in _files)
	{
		if (_includeLoad || split(file, "/").pop() != "load.nut")
		{
			::include(file);
		}
	}
}

local function includeLoad( _folder )
{
	::includeLoad("msu/", _folder);
}

includeLoad("ui");
includeLoad("systems");
includeLoad("config");
includeLoad("hooks");
includeLoad("msu_mod");
includeLoad("vanilla_mod");
includeLoad("test");

this.Const.World.RoadBrushes.add(::Const.Direction.N, "road_N");
this.Const.World.RoadBrushes.add(::Const.Direction.S, "road_S"); // idk where to put these
