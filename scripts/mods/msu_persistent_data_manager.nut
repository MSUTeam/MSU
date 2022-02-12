this.msu_persistent_data_manager <- {
	m = {
		ModConfigPath = "mod_config/"
		Mods = {}
	},
	
	function create()
	{
		this.importModConfigFiles()
	}
	

	function getMods()
	{
		return this.m.Mods
	}

	function getMod(_modID){
		if(!(_modID in this.getMods())){
			this.logError("No such mod config file: " + _modID)
			return false
		}
		return this.getMods()[_modID]
	}

	function loadSettingForMod(_modID, _settingID)
	{
		::printWarning(format("Loading setting '%s' for mod '%s'.", _settingID, _modID), this.MSU.MSUModName, "persistence");
		local mod = this.getMod(_modID)	
		if(mod && _settingID in mod){
			this.include(mod[_settingID])
			return true
		}
		return false

	}

	function loadSettingForEveryMod(_settingID){
		foreach(modID, modValue in this.getMods()){
			this.loadSettingForMod(modID, _settingID)
		}
	}

	function loadAllSettingsForMod(_modID, _settingID){
		local mod = this.getMod(_modID)
		if(mod){
			foreach(setting in mod){
				this.loadSettingForMod(_modID, setting)
			}
		}
	}

	function setMod(_modID, _reset = false){
		if(_modID in this.getMods() && _reset == false){
			return
		}
		this.getMods()[_modID] <- {}
	}


	function importModConfigFiles(){
		local persistentDirectory = this.IO.enumerateFiles(this.m.ModConfigPath)
		if (persistentDirectory == null){
			return
		}

		foreach(file in persistentDirectory){
			local components = split(file, "/")
			local modID = components[1]
			local settingsType = components[2]
			::printWarning(format("Checking file, potential modID: '%s' and settingstype '%s'.", modID, settingsType), this.MSU.MSUModName, "persistence");
			this.setMod(modID)
			if(!(settingsType in this.getMods()[modID])){
				this.getMods()[modID][settingsType] <- file
			}
		}
	}

	function writeToLog(_settingID, _modID, _content){
		this.logInfo(format("PARSEME;%s;%s;%s", _settingID, _modID, _content.tostring()))
	}
}