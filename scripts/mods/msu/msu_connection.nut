this.msu_connection <- this.inherit("scripts/mods/msu/js_connection", {
	m = {},

	function connect()
	{
		this.m.JSHandle = ::UI.connect("MSUConnection", this);
		this.queryData();
	}

	function queryData()
	{
		local data = {
			keybinds = ::MSU.System.Keybinds.getJSKeybinds(),
			settings = ::MSU.System.ModSettings.getLogicalData()
		};
		this.m.JSHandle.asyncCall("queryData", data);
	}

	function removeKeybind( _keybind )
	{
		this.m.JSHandle.asyncCall("removeKeybind", _keybind.getUIData())
	}

	function addKeybind( _keybind )
	{
		this.m.JSHandle.asyncCall("addKeybind", _keybind.getUIData())
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
