::MSU.Class.SerializationSystem <- class extends ::MSU.Class.System
{
	Mods = null;
	EmulatorsToClear = null;
	MetaData = null;

	constructor()
	{
		base.constructor(::MSU.SystemID.Serialization);
		this.Mods = [];
		this.EmulatorsToClear = [];
	}

	function registerMod( _mod )
	{
		base.registerMod(_mod);
		this.Mods.push(_mod);
		_mod.Serialization = ::MSU.Class.SerializationModAddon(_mod);
	}

	function flagSerialize( _mod, _id, _object, _flags = null )
	{
		if (::MSU.isBBObject(_object))
		{
			::logError("flagSerialize can't serialize a BB Object, you should use <object>.onSerialize(<Mod>.Serialization.getSerializationEmulator())");
			throw ::MSU.Exception.InvalidType("_object");
		}
		if (_flags == null) _flags = ::World.Flags;

		local outEmulator = ::MSU.Class.SerializationEmulator(_mod, _id, _flags);
		this.EmulatorsToClear.push(outEmulator);
		::MSU.Utils.serialize(_object, outEmulator);
		outEmulator.storeDataInFlagContainer(); // should we release data at this point?
	}

	function flagDeserialize( _mod, _id, _defaultValue, _object = null, _flags = null )
	{
		if (::MSU.isBBObject(_object))
		{
			::logError("flagDeserialize can't deserialize a BB Object, you should use <object>.onDeserialize(<Mod>.Serialization.getDeserializationEmulator())");
			throw ::MSU.Exception.InvalidType("_object");
		}
		if (_flags == null) _flags = ::World.Flags;

		local inEmulator = ::MSU.Class.DeserializationEmulator(_mod, _id, _flags);
		if (!inEmulator.loadDataFromFlagContainer())
			return _defaultValue;
		return _object == null ? ::MSU.Utils.deserialize(inEmulator) : ::MSU.Utils.deserializeInto(_object, inEmulator);
	}

	function getDeserializationEmulator( _mod, _id, _flags = null )
	{
		if (_flags == null) _flags = ::World.Flags;
		local emulator = ::MSU.Class.DeserializationEmulator(_mod, _id, _flags);
		emulator.loadDataFromFlagContainer();
		return emulator;
	}

	function getSerializationEmulator( _mod, _id, _flags = null )
	{
		if (_flags == null) _flags = ::World.Flags;
		local emulator = ::MSU.Class.SerializationEmulator(_mod, _id, _flags);
		emulator.setIncremental(true);
		this.EmulatorsToClear.push(emulator);
		return emulator;
	}

	function clearFlags()
	{
		foreach (flagContainer in this.EmulatorsToClear)
			flagContainer.clearFlags();
		this.EmulatorsToClear.clear();
	}
}
