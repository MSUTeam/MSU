this.MSU.Class.RangeSetting <- class extends this.MSU.Class.AbstractSetting
{
	Min = null;
	Max = null;
	Step = null;
	static Type = "Range";

	constructor( _id, _value, _min, _max, _step, _name = null )
	{
		base.constructor(_id, _value, _name);

		foreach (num in [_min, _max, _step])
		{
			if ((typeof num != "integer") && (typeof num != "float"))
			{
				this.logError("Max, Min and Step in a Range Setting have to be integers or floats");
				throw ::MSU.Exception.InvalidType;
			}
		}

		this.Min = _min;
		this.Max = _max;
		this.Step = _step;
	}

	function getMin()
	{
		return this.Min;
	}

	function getMax()
	{
		return this.Max;
	}

	function getStep()
	{
		return this.Step;
	}

	function getUIData()
	{
		local ret = base.getUIData();
		ret.min <- this.getMin();
		ret.max <- this.getMax();
		ret.step <- this.getStep();
		return ret;
	}

	function tostring()
	{
		return base.tostring() + " | Min: " + this.getMin() + " | Max: " + this.getMax() + " | Step: " + this.getStep();
	}
}
