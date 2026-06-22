var SliderSetting = function (_mod, _page, _setting, _parentDiv)
{
	RangeSetting.call(this, _mod, _page, _setting, _parentDiv);
};

// Inheritance in JS
SliderSetting.prototype = Object.create(RangeSetting.prototype);
Object.defineProperty(SliderSetting.prototype, 'constructor', {
	value: SliderSetting,
	enumerable: false,
	writable: true
});

// min/max/step are integer indices supplied by the nut side; value is an arbitrary
// array element, so the float-precision fixes from RangeSetting must not touch it.
SliderSetting.prototype.normalizeData = function ()
{
};

SliderSetting.prototype.getSliderValue = function ()
{
	return this.data.values.indexOf(this.data.value);
};

SliderSetting.prototype.getLabelText = function ()
{
	return '' + this.data.labels[this.data.values.indexOf(this.data.value)];
};

SliderSetting.prototype.onChange = function ()
{
	this.data.value = this.data.values[parseInt(this.slider.val())];
	this.label.text(this.getLabelText());
};
