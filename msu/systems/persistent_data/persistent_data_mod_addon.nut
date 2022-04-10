::MSU.Class.PersistentDataModAddon <- class extends ::MSU.Class.SystemModAddon
{
	function loadSetting( _settingID )
	{
		::MSU.System.PersistentData.loadSettingForMod(_settingID, this.Mod.getID());
	}

	function loadAllSettings()
	{
		::MSU.System.PersistentData.loadAllSettingsForMod(this.Mod.getID());
	}

	function writeToLog( _settingID, _payload)
	{
		::MSU.System.PersistentData.writeToLog(_settingID, this.Mod.getID(), _payload);
	}
}
