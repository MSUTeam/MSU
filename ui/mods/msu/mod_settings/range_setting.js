var RangeSetting = function (_mod, _page, _setting, _parentDiv)
{
	this.data = _setting;
	this.normalizeData();

	var self = this;

	// Calculate decimal places in step for formatting
	var stepString = _setting.step.toString();
	var decimalPlaces = stepString.indexOf('.') !== -1 ? stepString.split('.')[1].length : 0;

	this.layout = $('<div class="setting-container range-container"/>');
	_parentDiv.append(this.layout);

	this.titleContainer = $('<div class="setting-title-container"/>');
	this.layout.append(this.titleContainer);

	this.title = $('<div class="title title-font-normal font-color-title">' + _setting.name + '</div>');
	this.titleContainer.append(this.title);

	this.contentContainer = $('<div class="setting-content-container"/>');
	this.layout.append(this.contentContainer);

	this.control = $('<div class="scale-control"/>');
	this.contentContainer.append(this.control);

	this.slider = $('<input class="scale-slider" type="range"/>');
	this.control.append(this.slider);

	this.label = $('<div class="scale-label text-font-normal font-color-subtitle"></div>');
	this.control.append(this.label);

	this.layout.on("change", function ()
	{
		self.onChange();
	});

	if (_setting.locked)
	{
		this.slider.attr('disabled', true);
	}

	this.control.bindTooltip({ contentType: 'msu-generic', modId: MSU.ID, elementId: "ModSettings.Element.Tooltip", elementModId: _mod.id, settingsElementId: _setting.id });
	this.title.bindTooltip({ contentType: 'msu-generic', modId: MSU.ID, elementId: "ModSettings.Element.Tooltip", elementModId: _mod.id, settingsElementId: _setting.id });

	// Store precision on the object so updateValue can access it
	this.precision = decimalPlaces;
	this.updateValue();
};

// Fixes for JS/Squirrel float conversion weirdness on the numeric slider range.
RangeSetting.prototype.normalizeData = function ()
{
	var data = this.data;
	if (data.value % 1 != 0) data.value = parseFloat(data.value.toPrecision(6));
	if (data.min % 1 != 0) data.min = parseFloat(data.min.toPrecision(6));
	if (data.max % 1 != 0) data.max = parseFloat(data.max.toPrecision(6));
	if (data.step % 1 != 0) data.step = parseFloat(data.step.toPrecision(6));
};

// Position of the slider thumb. For a plain range this is just the value itself.
RangeSetting.prototype.getSliderValue = function ()
{
	return this.data.value;
};

// Text shown next to the slider.
RangeSetting.prototype.getLabelText = function ()
{
	return '' + this.data.value;
};

RangeSetting.prototype.onChange = function ()
{
	this.data.value = parseFloat(this.slider.val());
	this.label.text(this.getLabelText());
};

RangeSetting.prototype.updateValue = function ()
{
	this.slider.attr({
		min : this.data.min,
		max : this.data.max,
		step : this.data.step
	});
	this.slider.val(this.getSliderValue());
	this.label.text(this.getLabelText());
};

RangeSetting.prototype.unbindTooltip = function ()
{
	this.control.unbindTooltip();
	this.title.unbindTooltip();
};
