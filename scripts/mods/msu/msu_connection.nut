this.msu_connection <- this.inherit("scripts/mods/msu/js_connection", {
	m = {},

	function connect()
	{
		this.m.JSHandle = this.UI.connect("MSUConnection", this);
		this.passKeybinds();
		this.passSettings();
	}

	function passKeybinds()
	{
		this.m.JSHandle.asyncCall("setCustomKeybinds", this.MSU.CustomKeybinds.CustomBindsJS);
	}

	function passSettings()
	{
		this.m.JSHandle.asyncCall("setSettings", this.MSU.System.ModSettings.getLogicalData())
	}

	function updateSetting( _modID, _settingID, _value )
	{
		// Need to check in case settings are changed before backend is set up.
		if (this.m.JSHandle != null)
		{
			this.m.JSHandle.asyncCall("updateSetting", {
				mod = _modID,
				setting = _settingID,
				value = _value
			});
		}
	}

	function updateSettingJS( _data )
	{
		::getModSetting(_data.mod, _data.setting).set(_data.value, false);
	}
});
