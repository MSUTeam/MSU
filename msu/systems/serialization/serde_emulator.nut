// Base for the Serialization and Deserialization Emulators
::MSU.Class.SerDeEmulator <- class
{
	Data = null;
	Mod = null;
	ID = null;
	MetaData = null;

	constructor(_mod, _id, _metaDataEmulator = null)
	{
		if (_metaDataEmulator == null) _metaDataEmulator = ::MSU.Class.MetaDataEmulator();
		this.Data = [];
		this.Mod = _mod;
		this.ID = _id;
		this.MetaData = _metaDataEmulator;
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
		return this.MetaData;
	}
}
