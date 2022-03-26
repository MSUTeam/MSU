this.persistent_data_manager <- {
	m = {
		ModConfigPath = "mod_config/",
		Mods = {}
	},
	
	function create()
	{
		this.importModConfigFiles();
	}

	function importModConfigFiles()
	{
		local persistentDirectory = this.IO.enumerateFiles(this.m.ModConfigPath);
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
			this.setMod(modID);
			if (!(settingsType in this.m.Mods[modID]))
			{
				this.m.Mods[modID][settingsType] <- file;
			}
		}
	}

	function getMods()
	{
		return this.m.Mods;
	}

	function hasMod( _modID )
	{
		return (_modID in this.getMods());
	}

	function getMod( _modID )
	{
		if (!this.hasMod(_modID))
		{
			::logError("Mod " + _modID + " not found in mods!");
			throw ::MSU.Exception.KeyNotFound(_modID);
		}
		return this.m.Mods[_modID];
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
		foreach (modID, modValue in this.getMods())
		{
			this.loadSettingForMod(modID, _settingID);
		}
	}

	function loadAllSettingsForMod( _modID, _settingID )
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

	function setMod( _modID, _reset = false )
	{
		if (this.hasMod(_modID) && _reset == false)
		{
			return;
		}
		this.m.Mods[_modID] <- {};
	}

	function writeToLog( _settingID, _modID, _value )
	{
		::logInfo(format("BBPARSER;%s;%s;%s", _settingID.tostring(), _modID.tostring(), _value.tostring()));
	}
}
