::MSU.Class.PersistentDataSystem <- class extends ::MSU.Class.System
{
	Mods = null;
	ModConfigPath = "mod_config/";
	Separator = "@"

	constructor()
	{
		base.constructor(::MSU.SystemID.PersistentData);
		this.Mods = {};
	}

	function registerMod( _mod )
	{
		base.registerMod(_mod);

		_mod.PersistentData = ::MSU.Class.PersistentDataModAddon(_mod);
		this.addMod(_mod.getID());
		this.importModFiles(_mod.getID());
	}

	function importModFiles( _modID )
	{
		local persistentDirectory = this.IO.enumerateFiles(this.ModConfigPath + _modID);
		if (persistentDirectory == null)
		{
			return;
		}
		foreach (file in persistentDirectory)
		{
			local components = split(file, "/");
			local modID = components[1];
			local fileType = components[2];
			# ::MSU.Mod.Debug.printWarning(format("Checking file, potential modID: '%s' and fileType '%s'.", modID, fileType), "persistence");
			this.Mods[_modID][fileType] <- file;
		}
	}

	function addMod( _modID, _reset = false )
	{
		if (this.hasMod(_modID) && _reset == false)
		{
			return;
		}
		this.Mods[_modID] <- {};
	}

	function hasMod( _modID )
	{
		return _modID in this.Mods;
	}

	function getMod( _modID )
	{
		if (!this.hasMod(_modID))
		{
			::logError("Mod " + _modID + " not found in mods!");
			throw ::MSU.Exception.KeyNotFound(_modID);
		}
		return this.Mods[_modID];
	}

	function loadFileForMod( _modID, _fileID )
	{
		::MSU.Mod.Debug.printWarning(format("Loading file '%s' for mod '%s'.", _fileID, _modID), "persistence");
		if (_fileID in this.getMod(_modID))
		{
			::include(this.getMod(_modID)[_fileID]);
			return true;
		}
		return false;
	}

	function loadFileForEveryMod( _fileID )
	{
		foreach (modID, modValue in this.Mods)
		{
			this.loadFileForMod(modID, _fileID);
		}
	}

	function loadAllFilesForMod( _modID )
	{
		if (!this.hasMod(_modID))
		{
			::logError("Mod " + _modID + " not found in mods!");
			throw ::MSU.Exception.KeyNotFound(_modID);
		}

		foreach (file in this.getMod(_modID))
		{
			this.loadFileForMod(_modID, file);
		}
	}

	function writeToLog( _fileID, _modID, _payload )
	{
		local result = format("%sBBPARSER%s%s%s%s", this.Separator, this.Separator, _fileID, this.Separator, _modID);
		if (typeof _payload != "array")
		{
			_payload = [_payload];
		}
		foreach (arg in _payload)
		{
			::MSU.requireAnyTypeExcept(["array", "table", "class"], arg)
			result += this.Separator + arg;
		}
		result += this.Separator
		::logInfo(result);
	}
}
