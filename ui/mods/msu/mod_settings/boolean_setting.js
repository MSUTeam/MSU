var BooleanSetting = function (_mod, _page, _setting, _parentDiv)
{
	this.data = _setting;
	this.layout = $('<div class="setting-container boolean-container"/>');
	_parentDiv.append(this.layout);

	this.titleContainer = $('<div class="setting-title-container"/>');
	this.layout.append(this.titleContainer);

	var id = _mod.id + _setting.id + "-id"
	this.checkbox = $('<input type="checkbox" id= "' + id + '" name="' + _setting.id +'-name" />');
	this.titleContainer.append(this.checkbox);
	this.checkbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});
	this.checkbox.iCheck(_setting.value === true ? 'check' : 'uncheck');

	this.checkbox.on('ifChecked ifUnchecked', null, this, function (_event) {
		_setting.value = !_setting.value;
	});

	if (_setting.locked)
	{
		this.checkbox.attr('disabled', true);
	}

	this.title = $('<label class="bool-checkbox-label" for="' + id + '">' + _setting.name + '</label>');
	this.titleContainer.append(this.title);

	// Tooltip
	this.title.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
};

BooleanSetting.prototype.unbindTooltip = function ()
{
	this.title.unbindTooltip();
};
