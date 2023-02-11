this.msu_connection <- ::inherit("scripts/mods/msu/js_connection", {
	m = {},

	function connect()
	{
		this.m.JSHandle = ::UI.connect("MSUConnection", this);
		this.querySettingsData();
		this.checkForModUpdates();
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

	function checkForModUpdates()
	{
		this.m.JSHandle.asyncCall("checkForModUpdates", ::MSU.System.Registry.getModsForUpdateCheck());
	}

	function receiveModVersions( _modVersions )
	{
		::MSU.System.Registry.checkIfModVersionsAreNew(_modVersions);
	}

	function passTooltipIdentifiers(_table)
	{
		this.m.JSHandle.asyncCall("setTooltipImageKeywords", _table);
	}

	function queryZoomLevel()
	{
		local ret = {
			State = ::MSU.Utils.getActiveState().ClassName,
			Zoom = 1.0
		}
		if (ret.State == "tactical_state")
			ret.Zoom = ::Tactical.getCamera().Zoom;
		else if (ret.State == "world_state")
			ret.Zoom = ::World.getCamera().Zoom;
		return ret;
	}
});
