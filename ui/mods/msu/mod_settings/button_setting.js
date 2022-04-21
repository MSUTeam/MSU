var ButtonSetting = function (_mod, _page, _setting, _parentDiv)
{
	this.data = _setting;
	this.layout = $('<div class="setting-container button-container"/>');
	_parentDiv.append(this.layout);

	this.titleContainer = $('<div class="setting-title-container"/>');
	this.layout.append(this.titleContainer);

	this.title = $('<div class="title">' + _setting.name + '</div>');
	this.titleContainer.append(this.title);

	this.contentContainer = $('<div class="setting-content-container"/>');
	this.layout.append(this.contentContainer);

	this.button = this.contentContainer.createTextButton(_setting.value, function ()
	{
		var ret = {
			"modID" : _mod.id,
			"settingID" : _setting.id
		}
		Screens["ModSettingsScreen"].notifyBackendSettingButtonPressed(ret);
	}, 'button-setting-button', 4);

	if (_setting.locked)
	{
		this.button.attr('disabled', true);
	}

	// Tooltip
	this.title.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
	this.button.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
};

ButtonSetting.prototype.unbindTooltip = function ()
{
	this.title.unbindTooltip();
	this.button.unbindTooltip();
};
