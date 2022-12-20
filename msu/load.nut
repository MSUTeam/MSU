::MSU.includeLoad <- function( _prefix, _folder )
{
	::include(_prefix + _folder + "/load.nut");
}
::MSU.includeFile <- function( _prefix, _file )
{
	::include(_prefix + _file);
}
::MSU.includeFiles <- function( _files, _includeLoad = false )
{
	foreach (file in _files)
	{
		if (_includeLoad || split(file, "/").pop() != "load.nut")
		{
			::include(file);
		}
	}
}

// TODO: The old functions are converted to wrappers TEMPORARILY for the new MSU namespace functions.
// This is to help mods that may rely on these functions (e.g. Enduriel's mods) to function for now
// without requiring an update. These wrappers should be deleted in a future update after Enduriel updates his mods.
::includeLoad <- function( _prefix, _folder )
{
	::MSU.includeLoad(_prefix, _folder);
}
::includeFile <- function( _prefix, _file )
{
	::MSU.includeFile(_prefix, _file);	
}
::includeFiles <- function( _files, _includeLoad = false )
{
	::MSU.includeFiles(_files, _includeLoad);	
}

local function includeLoad( _folder )
{
	::MSU.includeLoad("msu/", _folder);
}

includeLoad("ui");
includeLoad("systems");
includeLoad("config");
includeLoad("hooks");
includeLoad("msu_mod");
includeLoad("vanilla_mod");
includeLoad("test");
