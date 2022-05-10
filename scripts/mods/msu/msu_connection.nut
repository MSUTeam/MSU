this.msu_connection <- ::inherit("scripts/mods/msu/js_connection", {
	m = {},

	function connect()
	{
		this.m.JSHandle = ::UI.connect("MSUConnection", this);
		this.queryData();
		this.checkMSUGithubVersion();
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
		if (this.m.JSHandle != null)
		{
			this.m.JSHandle.asyncCall("removeKeybind", _keybind.getUIData())
		}
	}

	function addKeybind( _keybind )
	{
		if (this.m.JSHandle != null)
		{
			this.m.JSHandle.asyncCall("addKeybind", _keybind.getUIData())
		}
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

	function checkMSUGithubVersion()
	{
		this.m.JSHandle.asyncCall("checkMSUGithubVersion", null);
	}

	function getMSUGithubVersion( _version )
	{
		if (::MSU.SemVer.compareMajorVersionWithOperator(_version, "=", ::MSU.Version))
		{
			if (::MSU.SemVer.compareMinorVersionWithOperator(_version, ">", ::MSU.Version))
			{
				::MSU.Popup.showRawText("MSU has an update with new features and bugfixes available! You can go ahead and <a style=\"color: lightblue; text-decoration: underline;\"onclick=\"openURL('https://www.nexusmods.com/battlebrothers/mods/479')\">download it from NexusMods</a>")
			}
			else if (::MSU.SemVer.compareVersionWithOperator(_version, ">", ::MSU.Version))
			{
				::MSU.Popup.showRawText("MSU has an update with new bugfixes available! <a style=\"color: lightblue; text-decoration: underline;\"onclick=\"openURL('https://www.nexusmods.com/battlebrothers/mods/479')\">Download it from NexusMods</a> to prevent bugs")
			}
		}
	}

	function updateSettingJS( _data )
	{
		::getModSetting(_data.mod, _data.setting).set(_data.value, false);
	}

	function clearKeys()
	{
		this.m.JSHandle.asyncCall("clearKeys", null);
	}
});
