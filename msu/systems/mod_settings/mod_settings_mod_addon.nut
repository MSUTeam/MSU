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

	function getAllElementsAsArray( _filter = null )
	{
		return this.getPanel().getAllElementsAsArray(_filter);
	}

	function resetSettings()
	{
		return this.getPanel().resetSettings();
	}

	function hasSetting( _settingID )
	{
		return ::MSU.System.ModSettings.getPanel(this.Mod.getID()).hasSetting(_settingID);
	}

	function requireSettingValue( _setting, _value )
	{
		if (_setting.getValue() != _value)
		{
			if (_setting.isLocked())
			{
				::MSU.QueueErrors.add("Mod " + this.getMod().getID() + " (" + this.getMod().getName() + ") requires setting \'" + _setting.getID() + "\' of mod \'" + _setting.getMod().getID() + " (" + _setting.getMod().getName() + ")\' to have the value \'" + _value + "\' but it is locked to be \'" + _setting.getValue() + "\'. Lock reason: " + _setting.getLockReason() + ".");
				return false;
			}

			if (_setting.set(_value))
			{
				_setting.lock("Required by Mod " + this.getMod().getID() + " (" + this.getMod().getName() + ")");
				return true;
			}
			else
			{
				::MSU.QueueErrors.add("Mod " + this.getMod().getID() + " (" + this.getMod().getName() + ") failed to set \'" + _setting.getID() + "\' of mod \'" + _setting.getMod().getID() + " (" + _setting.getMod().getName() + ")\' to the value \'" + _value + "\'.");
				return false;
			}
		}

		_setting.lock("Required by Mod " + this.getMod().getID() + " (" + this.getMod().getName() + ")");

		return true;
	}
}
