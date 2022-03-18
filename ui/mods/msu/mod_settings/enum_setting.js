var EnumSetting = function (_mod, _page, _setting, _parentDiv)
{
	var self = this;
	this.setting = _setting;
	this.idx = _setting.array.indexOf(_setting.value);
	if (this.idx == -1)
	{
		console.error("EnumSetting Error");
	}

	this.layout = $('<div class="enum-container"/>');
	_parentDiv.append(this.layout);

	this.title = $('<div class="title title-font-big font-bold font-color-title">' + _setting.name + '</div>');
	this.layout.append(this.title);

	this.button = this.layout.createTextButton(_setting.value, function ()
	{
		self.cycle(true);
	}, 'enum-button', 4);

	this.button.mousedown(function (event)
	{
		if (event.which === 3)
		{
			self.cycle(false);
		}
	});

	if (_setting.locked)
	{
		this.button.attr('disabled', true);
	}

	// Tooltip
	this.title.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
	this.button.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
}

EnumSetting.prototype.cycle = function (_forward)
{
	this.idx += _forward ? 1 : -1;
	if (this.idx == -1)
	{
		this.idx = this.setting.array.length - 1;
	}
	else if (this.idx == this.setting.array.length)
	{
		this.idx = 0;
	}
	this.setting.value = this.setting.array[this.idx];
	this.button.changeButtonText(this.setting.value);
}

EnumSetting.prototype.unbindTooltip = function ()
{
	this.title.unbindTooltip();
	this.button.unbindTooltip();
}
