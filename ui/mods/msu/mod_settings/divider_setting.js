var DividerSetting = function (_mod, _page, _setting, _parentDiv)
{
	this.layout = $('<div class="divider"/>');
	_parentDiv.append(this.layout);

	var line = $('<div class="gold-line"/>');
	this.layout.append(line);

	if (_setting.name != "")
	{
		this.title = $('<div class="title title-font-big font-bold font-color-title">' + _setting.name + '</div>');
		this.layout.append(this.title);
		this.layout.css("height", "3.0rem");
		line.css("top", "3.0rem");
		this.title.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
	}
}

DividerSetting.prototype.unbindTooltip = function ()
{
	if ('title' in this)
	{
		this.title.unbindTooltip();
	}
}
