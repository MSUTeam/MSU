var ButtonSetting = function (_mod, _page, _setting, _parentDiv)
{
	var self = this;
	this.layout = $('<div class="button-container"/>');
	_parentDiv.append(this.layout);
	this.title = $('<div class="title title-font-big font-bold font-color-title">' + _setting.name + '</div>');
	this.layout.append(this.title);

	this.button = this.layout.createTextButton(_setting.value, function ()
	{
		var ret = {
			"modID" : _mod.id,
			"settingID" : _setting.id
		}
		Screens["ModSettingsScreen"].notifyBackendSettingButtonPressed(ret);
	}, 'enum-button', 4);

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
