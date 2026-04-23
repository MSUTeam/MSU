::MSU.Class.SliderSetting <- class extends ::MSU.Class.RangeSetting
{
	Values = null;
	Labels = null;
	static Type = "Slider";

	constructor( _id, _value, _values, _labels = null, _name = null, _description = null )
	{
		if (_values.find(_value) == null)
		{
			::logError("SliderSetting: _value must be an element in _values");
			throw ::MSU.Exception.KeyNotFound(_value);
		}
		if (_labels == null)
		{
			_labels = _values;
		}
		assert(_values.len() == _labels.len());

		base.constructor(_id, _value, 0, _values.len() - 1, 1, _name, _description);
		this.Values = _values;
		this.Labels = _labels;
	}

	function getUIData( _flags = [] )
	{
		local ret = base.getUIData(_flags);
		ret.values <- this.Values;
		ret.labels <- this.Labels;
		return ret;
	}

	function tostring()
	{
		local ret = base.tostring() + " | Values: \n";
		foreach (value in this.Values)
		{
			ret += value + "\n";
		}
		ret += " | Labels: \n";
		foreach (label in this.Labels)
		{
			ret += label + "\n";
		}
		return ret;
	}

	function flagDeserialize( _in )
	{
		base.flagDeserialize(_in);
		if (this.Values.find(this.Value) == null)
		{
			::logError("Value \'" + this.Value + "\' not contained in array for setting " + this.getID() + " in mod " + this.getMod().getID());
			this.reset();
		}
	}
}
