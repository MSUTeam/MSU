var StringSetting = function (_mod, _page, _setting, _parentDiv)
{
	var self = this;
	this.layout = $('<div class="string-container"/>');
	this.setting = _setting;
	_parentDiv.append(this.layout);

	this.title = $('<div class="title title-font-big font-bold font-color-title">' + _setting.name + '</div>');
	this.layout.append(this.title);

	this.input = $('<input type="text" class="title-font-big font-bold font-color-brother-name string-input"/>');
	this.input.val(_setting.value);
	this.input.on("change", function(){
		self.setting.value = self.input.val();
	});


	this.layout.append(this.input);

	// Tooltip
	this.title.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
	this.input.bindTooltip({ contentType: 'ui-element', elementId: "msu-settings." + _mod.id + "." + _setting.id });
};

StringSetting.prototype.unbindTooltip = function ()
{
	this.title.unbindTooltip();
	this.input.unbindTooltip();
};
