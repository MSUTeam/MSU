::MSU.Class.SerializationSystem <- class extends ::MSU.Class.System
{
	Mods = [];

	constructor()
	{
		base.constructor(::MSU.SystemID.Serialization);
	}

	function registerMod( _mod )
	{
		base.registerMod(_mod);
		this.Mods.push(_mod);
		_mod.Serialization = ::MSU.Class.SerializationModAddon(_mod);
	}
}
