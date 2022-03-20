::MSU.Class.ModSettingsModAddon <- class extends ::MSU.Class.SystemModAddon
{
	function getPanel()
	{
		return ::MSU.System.ModSettings.get(this.Mod.getID());
	}

	function addPage( _page )
	{
		::MSU.System.ModSettings.get(this.Mod.getID()).addPage(_page);
	}

	function addPageElement( _pageID, _element )
	{
		::MSU.System.ModSettings.get(this.Mod.getID()).getPage(_page).add(_element);
	}

	function getSetting( _settingID )
	{
		return ::MSU.System.ModSettings.get(this.Mod.getID()).getSetting(_settingID);
	}

	function hasSetting( _settingID )
	{
		return ::MSU.System.ModSettings.get(this.Mod.getID()).hasSetting(_settingID);
	}
}
