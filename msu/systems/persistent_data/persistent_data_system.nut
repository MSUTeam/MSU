::MSU.Class.PersistentDataSystem <- class extends ::MSU.Class.System
{
	Mods = null;
	ModConfigPath = "mod_config/";

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
		this.importModConfigFiles(_mod.getID());
	}

	function importModConfigFiles( _modID )
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
			local settingsType = components[2];
			::MSU.Mod.Debug.printWarning(format("Checking file, potential modID: '%s' and settingstype '%s'.", modID, settingsType), "persistence");
			this.Mods[_modID][settingsType] <- file;
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
		return (_modID in this.Mods);
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

	function loadSettingForMod( _modID, _settingID )
	{
		::MSU.Mod.Debug.printWarning(format("Loading setting '%s' for mod '%s'.", _settingID, _modID), "persistence");
		if (_settingID in this.getMod(_modID))
		{
			::include(this.getMod(_modID)[_settingID]);
			return true;
		}
		return false;
	}

	function loadSettingForEveryMod( _settingID )
	{
		foreach (modID, modValue in this.Mods)
		{
			this.loadSettingForMod(modID, _settingID);
		}
	}

	function loadAllSettingsForMod( _modID )
	{
		if (!this.hasMod(_modID))
		{
			::logError("Mod " + _modID + " not found in mods!");
			throw ::MSU.Exception.KeyNotFound(_modID);
		}

		foreach (setting in this.getMod(_modID))
		{
			this.loadSettingForMod(_modID, setting);
		}
	}

	function writeToLog( _type, _modID, _payload )
	{
		local result = format("BBPARSER;%s;%s", _type, _modID);
		if (typeof _payload != "array")
		{
			_payload = [_payload];
		}
		foreach (arg in _payload)
		{
			::MSU.requireAllButTypes(["array", "table"], arg)
			result += ";" + arg.tostring();
		}
		::logInfo(result);
	}
}
