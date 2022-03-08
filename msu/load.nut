local prefix = "msu/"
::includeLoad <- function( _prefix, _folder )
{
	this.include(_prefix + _folder + "/load.nut");
}
::includeFile <- function( _prefix, _file )
{
	this.include(_prefix + _file);
}
::includeFiles <- function( _files, _includeLoad = false )
{
	foreach (file in _files)
	{
		if (split(file, "/").pop() != "load.nut" || _includeLoad)
		{
			this.include(file);
		}
	}
}

local function includeLoad(_folder)
{
	::includeLoad("msu/", _folder);
}

includeLoad("utilities");
includeLoad("classes");
includeLoad("ui");
includeLoad("systems");
includeLoad("config");
includeLoad("keyhandling");

includeLoad("hooks");
