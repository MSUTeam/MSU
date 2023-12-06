var ButtonSetting = function (_mod, _page, _setting, _parentDiv)
{
	this.data = _setting;
	this.layout = $('<div class="setting-container button-container"/>');
	_parentDiv.append(this.layout);

	this.contentContainer = $('<div class="setting-content-container"/>');
	this.layout.append(this.contentContainer);

	this.button = this.contentContainer.createTextButton(_setting.name, function ()
	{
		var ret = {
			"modID" : _mod.id,
			"settingID" : _setting.id
		}
		Screens.ModSettingsScreen.notifyBackendSettingButtonPressed(ret);
	}, 'msu-button button-setting-button');

	if (_setting.locked)
	{
		this.button.attr('disabled', true);
	}

	// Tooltip
	this.button.bindTooltip({ contentType: 'msu-generic', modId: MSU.ID, elementId: "ModSettings.Element.Tooltip", elementModId: _mod.id, settingsElementId: _setting.id });
};

ButtonSetting.prototype.unbindTooltip = function ()
{
	this.button.unbindTooltip();
};
