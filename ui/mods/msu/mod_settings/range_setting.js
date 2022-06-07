var RangeSetting = function (_mod, _page, _setting, _parentDiv)
{
	this.data = _setting;
	var self = this;
	this.layout = $('<div class="setting-container range-container"/>');
	_parentDiv.append(this.layout);

	this.titleContainer = $('<div class="setting-title-container"/>');
	this.layout.append(this.titleContainer);

	this.title = $('<div class="title">' + _setting.name + '</div>');
	this.titleContainer.append(this.title);

	this.contentContainer = $('<div class="setting-content-container"/>');
	this.layout.append(this.contentContainer);

	this.control = $('<div class="scale-control"/>');
	this.contentContainer.append(this.control);

	this.slider = $('<input class="scale-slider" type="range"/>');
	this.updateValue();
	this.control.append(this.slider);

	this.label = $('<div class="scale-label text-font-normal font-color-subtitle">' + _setting.value + '</div>');
	this.control.append(this.label);

	this.layout.on("change", function ()
	{
		_setting.value = parseFloat(self.slider.val());
		self.label.text('' + _setting.value);
	});

	if (_setting.locked)
	{
		this.slider.attr('disabled', true);
	}

	// Tooltip
	this.control.bindTooltip({ contentType: 'msu-generic', modId: MSU.ID, elementId: "ModSettings.Element.Tooltip", elementModId: _mod.id, settingsElementId: _setting.id });
	this.title.bindTooltip({ contentType: 'msu-generic', modId: MSU.ID, elementId: "ModSettings.Element.Tooltip", elementModId: _mod.id, settingsElementId: _setting.id });
};

RangeSetting.prototype.updateValue = function()
{
	this.slider.attr({
		min : this.data.min,
		max : this.data.max,
		step : this.data.step
	});
	this.slider.val(this.data.value);
}

RangeSetting.prototype.unbindTooltip = function ()
{
	this.control.unbindTooltip();
	this.title.unbindTooltip();
};
