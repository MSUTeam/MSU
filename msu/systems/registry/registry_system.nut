this.MSU.Class.ModRegistrySystem <- class extends this.MSU.Class.System
{
	Mods = null;
	constructor()
	{
		base.constructor(this.MSU.SystemID.ModRegistry);
		this.Mods = {}
	}

	function registerMod( _modID, _version, _modName = null )
	{
		if (_modID in this.Mods)
		{
			this.logError("Duplicate Mod ID for mod: " + _modID);
			throw this.Exception.DuplicateKey;
		}
		else if (::mods_getRegisteredMod(_modID) == null)
		{
			this.logError("Register your mod using the same ID with mod_hooks before registering with MSU");
			throw this.Exception.KeyNotFound;
		}

		local mod = this.MSU.Class.Mod(_modID, _version, _modName);
		this.Mods[_modID] <- mod;
		this.logInfo(format("MSU registered mod %s, version: %s", mod.getName(), mod.getVersionString()));
	}
}
