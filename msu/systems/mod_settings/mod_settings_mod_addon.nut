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
		::MSU.System.ModSettings.registerRequiredSettingValue(this.getMod(), _setting, _value);
		return ::MSU.System.ModSettings.requireSettingValue(this.getMod(), _setting, _value);
	}

	function lockSetting( _setting, _lockReason )
	{
		if (typeof _setting == "string") _setting = this.getSetting(_setting);

		_setting.lock(_lockReason + format(" (%s (%s))", this.getMod().getID(), this.getMod().getName()));
	}
}
