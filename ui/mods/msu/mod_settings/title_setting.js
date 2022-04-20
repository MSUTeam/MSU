var TitleSetting = function (_mod, _page, _setting, _parentDiv)
{
	this.data = _setting;
	this.layout = $('<div class="title-container"/>');
	_parentDiv.append(this.layout);
	this.title = $('<div class="title title-font-big font-bold font-color-title">' + _setting.name + '</div>');
	this.layout.append(this.title);
	this.title.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
};

TitleSetting.prototype.unbindTooltip = function ()
{
	this.title.unbindTooltip();
};
