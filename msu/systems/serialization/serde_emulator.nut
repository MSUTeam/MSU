::MSU.Class.SerDeEmulator <- class
{
	Data = null;
	Mod = null;
	ID = null;

	constructor(_mod, _id)
	{
		this.Data = [];
		this.Mod = _mod;
		this.ID = _id;
	}

	function getEmulatorString()
	{
		return format("MSU.%s.%s", this.Mod.getID(), this.ID);
	}

	function clearFlagContainer( _flags )
	{
		local startString = this.getEmulatorString();
		_flags.remove(startString);
		for (local i = 0; i < this.Data.len(); ++i)
		{
			_flags.remove(startString + "." + i);
		}
	}

	function getMetaData()
	{
		return ::MSU.Metadata;
	}
}
