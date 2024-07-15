this.msu_connection <- ::inherit("scripts/mods/msu/js_connection", {
	m = {},

	function connect()
	{
		this.m.JSHandle = ::UI.connect("MSUConnection", this);
		this.querySettingsData();
		this.checkForModUpdates();
		this.updateNestedTooltipTextStyle();
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

	function updateNestedTooltipTextStyle()
	{
		local styleString = format("color: rgba(%s);", ::getModSetting("mod_msu", "NestedTooltips_Color").getValue());
		if (::getModSetting("mod_msu", "NestedTooltips_Bold").getValue()) styleString += "font-weight: bold;";
		if (::getModSetting("mod_msu", "NestedTooltips_Italic").getValue()) styleString += "font-style: italic;";
		if (::getModSetting("mod_msu", "NestedTooltips_Underline").getValue()) styleString += "text-decoration: underline;";
		this.m.JSHandle.asyncCall("updateNestedTooltipTextStyle", styleString);
	}
});
