var SliderSetting = function (_mod, _page, _setting, _parentDiv)
{
	_setting.value = _setting.values.indexOf(_setting.value);
	RangeSetting.call(this, _mod, _page, _setting, _parentDiv);
	_setting.value = _setting.values[_setting.value];

	// Only need to set it once
	this.slider.attr({min: this.data.min, max: this.data.max, step: this.data.step});

	this.layout.off("change");
	this.layout.on("change", this.onChange.bind(this));
	this.updateValue();
};
SliderSetting.prototype.__proto__ = RangeSetting.prototype;

SliderSetting.prototype.updateValue = function ()
{
	var index = this.data.values.indexOf(this.data.value);
	this.slider.val(index);
	this.label.text('' + this.data.labels[index]);
};

SliderSetting.prototype.onChange = function ()
{
	var index = parseInt(this.slider.val());
	this.data.value = this.data.values[index];
	this.label.text('' + this.data.labels[index]);
};
