this.msu_connection <- ::inherit("scripts/mods/msu/js_connection", {
	m = {},

	function connect()
	{
		this.m.JSHandle = ::UI.connect("MSUConnection", this);
		this.querySettingsData();
		this.checkMSUGithubVersion();
	}

	function querySettingsData()
	{
		local data = {
			keybinds = ::MSU.System.Keybinds.getJSKeybinds(),
			settings = ::MSU.System.ModSettings.getUIData()
		};
		this.m.JSHandle.asyncCall("onQuerySettingsData", data);
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

	function clearKeys()
	{
		this.m.JSHandle.asyncCall("clearKeys", null);
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


});
