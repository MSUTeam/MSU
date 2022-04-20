var DividerSetting = function (_mod, _page, _setting, _parentDiv)
{
	this.data = _setting;
	this.layout = $('<div class="divider"/>');
	_parentDiv.append(this.layout);

	var line = $('<div class="gold-line"/>');
	this.layout.append(line);
};

DividerSetting.prototype.unbindTooltip = function ()
{
};
