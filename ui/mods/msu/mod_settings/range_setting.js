var RangeSetting = function (_mod, _page, _setting, _parentDiv)
{
	var self = this;
	this.layout = $('<div class="range-container outline"/>');
	_parentDiv.append(this.layout);

	this.title = $('<div class="title title-font-big font-bold font-color-title outline">' + _setting.name + '</div>');
	this.layout.append(this.title);

	this.control = $('<div class="scale-control"/>');
	this.layout.append(this.control);

	this.slider = $('<input class="scale-slider" type="range"/>');
	this.slider.attr({
		min : _setting.min,
		max : _setting.max,
		step : _setting.step
	});
	this.slider.val(_setting.value);
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
	this.control.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
	this.title.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
}

RangeSetting.prototype.unbindTooltip = function ()
{
	this.control.unbindTooltip();
	this.title.unbindTooltip();
}
