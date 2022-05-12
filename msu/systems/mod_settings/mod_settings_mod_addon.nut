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

	function addPage( _pageID, _pageName = null )
	{
		local page = ::MSU.Class.SettingsPage(_pageID, _pageName);
		this.getPanel().addPage(page);
		return page;
	}

	function getSetting( _settingID )
	{
		return ::MSU.System.ModSettings.getPanel(this.Mod.getID()).getSetting(_settingID);
	}

	function getAllSettings()
	{
		local ret = [];
		foreach (page in this.getPanel().getPages())
		{
			foreach (setting in page.getSettings())
			{
				ret.push(setting);
			}
		}
		return ret;
	}

	function hasSetting( _settingID )
	{
		return ::MSU.System.ModSettings.getPanel(this.Mod.getID()).hasSetting(_settingID);
	}
}
