this.MSU.Class.EnumSetting <- class extends this.MSU.Class.AbstractSetting
{
	Array = null;
	static Type = "Enum";

	constructor( _id, _value, _array, _name = null )
	{
		if (_array.find(_value) == null)
		{
			this.logError("Value must be an element in the Array");
			throw this.Exception.KeyNotFound;
		}
		base.constructor(_id, _value, _name);
		this.Array = _array;
	}

	function getUIData()
	{
		local ret = base.getUIData();
		ret.array <- this.Array;
		return ret;
	}

	function tostring()
	{
		local ret = base.tostring() + " | Array: \n";
		foreach (value in this.Array)
		{
			ret += value + "\n";
		}
		return ret;
	}

	function flagDeserialize(_modID)
	{
		base.flagDeserialize(_modID);
		if (this.Array.find(this.Value) == null)
		{
			this.logError("Value \'" + this.Value + "\' not contained in array for setting " + this.getID() + " in mod " + _modID);
			this.Value = this.Array[0];
		}
	}

	//Note the Array ISN'T serialized
}
