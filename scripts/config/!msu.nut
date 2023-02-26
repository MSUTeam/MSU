::MSU <- {
	Version = "1.2.0-rc.4",
	ID = "mod_msu",
	Name = "Modding Standards & Utilities (MSU)",
	VanillaID = "vanilla",
	Class = {},
	BBClass = {
		Empty = "scripts/mods/msu/empty_bb_class"
	}
};

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

::MSU.includeFiles(::IO.enumerateFiles("msu/utils"));
::MSU.includeFiles(::IO.enumerateFiles("msu/classes"));
