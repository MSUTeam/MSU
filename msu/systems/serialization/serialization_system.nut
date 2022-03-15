this.MSU.Class.SerializationSystem <- class extends this.MSU.Class.System
{
	Mods = [];

	constructor()
	{
		base.constructor(this.MSU.SystemID.Serialization);
	}

	function registerMod( _mod )
	{
		base.registerMod(_mod);
		this.Mods.push(_mod);
	}
}
