this.MSU.Class.SerializationSystem <- class extends this.MSU.Class.System
{
	Mods = [];

	constructor()
	{
		base.constructor(this.MSU.SystemIDs.Serialization, [this.MSU.SystemIDs.ModRegistry]);
	}

	function registerMod( _modID )
	{
		base.registerMod(_modID);
		this.Mods.push(this.MSU.Mods[_modID]);
	}
}