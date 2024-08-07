::MSU.Class.FlagSerDeEmulator <- class extends ::MSU.Class.SerDeEmulator
{
	static __IDRegex = regexp("^.*\\.\\d+$");
	ID = null;
	Mod = null;
	Data = null;
	FlagContainer = null;

	constructor( _mod, _id, _flagContainer, _metaDataEmulator )
	{
		if (this.__IDRegex.match(_id))
		{
			::logError("the ID passed to flag serialization cannot end with a full stop followed by digits so it doesn't collide with internal MSU flags");
			throw ::MSU.Exception.InvalidValue(_id);
		}
		base.constructor(_metaDataEmulator);
		this.Mod = _mod;
		this.ID = _id;
		this.FlagContainer = _flagContainer;
	}

	function getEmulatorString()
	{
		return format("MSU.%s.%s", this.Mod.getID(), this.ID);
	}

	function clearFlags()
	{
		local startString = this.getEmulatorString();
		this.FlagContainer.remove(startString);
		for (local i = 0; i < this.SerializationData.len(); ++i)
		{
			this.FlagContainer.remove(startString + "." + i);
			this.FlagContainer.remove(startString + ".type." + i);
			this.FlagContainer.remove(startString + ".data." + i);
		}
	}
}
