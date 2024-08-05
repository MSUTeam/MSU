this.msu_connection <- ::inherit("scripts/mods/msu/js_connection", {
	m = {
		FunctionBuffer = []
	},

	function connect()
	{
		this.m.JSHandle = ::UI.connect("MSUConnection", this);
		this.querySettingsData();
		this.checkForModUpdates();
		foreach (fn in this.m.FunctionBuffer)
		{
			fn();
		}
		this.m.FunctionBuffer.clear();
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
		else
		{
			this.m.FunctionBuffer.push(@() this.removeKeybind(_keybind));
		}
	}

	function addKeybind( _keybind )
	{
		if (this.m.JSHandle != null)
		{
			::logInfo("msu_connection addKeybind: " + _keybind.getID());
			this.m.JSHandle.asyncCall("addKeybind", _keybind.getUIData())
		}
		else
		{
			this.m.FunctionBuffer.push(@() this.addKeybind(_keybind));
		}
	}

	function clearKeys()
	{
		this.m.JSHandle.asyncCall("clearKeys", null);
	}

	function setInputDenied( _bool )
	{
		::MSU.System.Keybinds.InputDenied = _bool;
	}

	function checkForModUpdates()
	{
		this.m.JSHandle.asyncCall("checkForModUpdates", ::MSU.System.Registry.getModsForUpdateCheck());
	}

	function compareModVersions( _modVersionData )
	{
		return ::MSU.System.Registry.checkIfModVersionsAreNew(_modVersionData);
	}

	function onVanillaBBCodeUpdated( _bool )
	{
		if (this.m.JSHandle != null)
		{
			this.m.JSHandle.asyncCall("onVanillaBBCodeUpdated", _bool);
		}
		else
		{
			this.m.FunctionBuffer.push(function() {
				this.onVanillaBBCodeUpdated(_bool);
			});
		}
	}
});
