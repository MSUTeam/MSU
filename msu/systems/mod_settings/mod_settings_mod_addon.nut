::MSU.Class.ModSettingsModAddon <- class extends ::MSU.Class.SystemModAddon
{
	function getPanel()
	{
		return ::MSU.System.ModSettings.get(this.getID());
	}

	function addPage( _page )
	{
		::MSU.System.ModSettings.get(this.getID()).addPage(_page);
	}

	function addPageElement( _pageID, _element )
	{
		::MSU.System.ModSettings.get(this.getID()).getPage(_page).add(_element);
	}

	function getSetting( _settingID )
	{
		return ::MSU.System.ModSettings.get(this.getID()).getSetting(_settingID);
	}
}
