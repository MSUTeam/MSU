::MSU.Class.SerializationSystem <- class extends ::MSU.Class.System
{
	Mods = null;
	FlagBasedSerializationObjects = null;
	SerializationFlags = null;

	constructor()
	{
		base.constructor(::MSU.SystemID.Serialization);
		this.Mods = [];
		this.FlagBasedSerializationObjects = [];
		this.SerializationFlags = [];
	}

	function registerMod( _mod )
	{
		base.registerMod(_mod);
		this.Mods.push(_mod);
		_mod.Serialization = ::MSU.Class.SerializationModAddon(_mod);
	}

	function getFlagBasedSerializationObjects()
	{
		return this.FlagBasedSerializationObjects;
	}

	function clearFlagBasedSerializationObjects()
	{
		this.FlagBasedSerializationObjects.clear();
	}

	function addForFlagBasedSerialization( _instance )
	{
		this.FlagBasedSerializationObjects.push(_instance);
	}

	function getWorldFlag( _name )
	{
		local flagName = this.Mod.getID() + _name;
		return ::World.Flags.has(flagName) ? ::World.Flags.get(this.Mod.getID() + _name) : null;
	}

	function setWorldFlag( _name, _value )
	{
		local flagName = this.Mod.getID() + _name;
		::World.Flags.set(flagName), _value);
		this.SerializationFlags.push(flagName);
	}

	function clearSerializationFlags()
	{
		foreach (flagName in this.SerializationFlags)
		{
			::World.Flags.remove(flagName);
		}
		this.SerializationFlags.clear();
	}

	function writeInt( _name, _value )
	{
		::MSU.requireString(_name);
		::MSU.requireInt(_value);
		this.setWorldFlag(_name, _value);
	}

	function readInt( _name )
	{
		return this.getWorldFlag(_name);
	}

	function writeBool( _name, _value )
	{
		::MSU.requireString(_name);
		::MSU.requireBool(_value);
		this.setWorldFlag(_name, _value);
	}

	function readBool( _name )
	{
		return this.getWorldFlag(_name);
	}

	function writeString( _name, _value )
	{
		::MSU.requireString(_name, _value);
		this.setWorldFlag(_name, _value);
	}

	function readString( _name )
	{
		return this.getWorldFlag(_name);
	}
}
