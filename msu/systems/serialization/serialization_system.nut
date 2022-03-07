this.MSU.Class.SerializationSystem <- class extends this.MSU.Class.System
{
	Mods = [];

	constructor()
	{
		base.constructor(this.MSU.SystemID.Serialization, [this.MSU.SystemID.ModRegistry]);
	}

	function registerMod( _modID )
	{
		base.registerMod(_modID);
		this.Mods.push(this.MSU.Mods[_modID]);
	}
}
