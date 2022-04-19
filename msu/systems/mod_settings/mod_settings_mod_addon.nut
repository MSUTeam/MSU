::MSU.Class.ModSettingsModAddon <- class extends ::MSU.Class.SystemModAddon
{
	function getPanel()
	{
		return ::MSU.System.ModSettings.getPanel(this.Mod.getID());
	}

	function getPage( _pageID )
	{
		return this.getPanel().getPage(_pageID);
	}

	function addPage( _pageID )
	{
		local page = ::MSU.Class.SettingsPage(_pageID);
		this.getPanel().addPage(page);
		return page;
	}

	function addElementToPage( _pageID, _element )
	{
		this.getPage(_pageID).add(_element);
		return _element;
	}

	function addDividerToPage( _pageID, _id, _title = "")
	{
		return this.addElementToPage(_pageID, ::MSU.Class.SettingsDivider(_id, _title));
	}

	function getSetting( _settingID )
	{
		return ::MSU.System.ModSettings.getPanel(this.Mod.getID()).getSetting(_settingID);
	}

	function hasSetting( _settingID )
	{
		return ::MSU.System.ModSettings.getPanel(this.Mod.getID()).hasSetting(_settingID);
	}
}
