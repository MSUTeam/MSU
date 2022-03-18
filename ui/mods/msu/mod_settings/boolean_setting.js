var BooleanSetting = function (_mod, _page, _setting, _parentDiv)
{
	this.layout = $('<div class="boolean-container"/>');
	_parentDiv.append(this.layout);
	this.checkbox = $('<input type="checkbox" id= "' + _setting.id + '-id" name="' + _setting.id +'-name" />');
	this.layout.append(this.checkbox);
	this.label = $('<label class="text-font-normal font-color-subtitle" for="cb-camera-adjust">' + _setting.name + '</label>');
	this.layout.append(this.label);
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

	// Tooltip
	this.label.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
}

BooleanSetting.prototype.unbindTooltip = function ()
{
	this.label.unbindTooltip();
}
