::MSU.Class.RegistrySystem <- class extends ::MSU.Class.System
{
	Mods = null;
	constructor()
	{
		base.constructor(::MSU.SystemID.Registry);
		this.Mods = {};
	}

	function addMod( _mod )
	{
		this.Mods[_mod.getID()] <- _mod;
		::logInfo(format("MSU registered mod %s, version: %s", _mod.getName(), _mod.getVersionString()));
	}

	function registerMod( _mod )
	{
		if (_mod.getID() in this.Mods)
		{
			::logError("Duplicate Mod ID for mod: " + _mod.getID());
			throw ::MSU.Exception.DuplicateKey(_mod.getID());
		}
		else if (::mods_getRegisteredMod(_mod.getID()) == null && _mod.getID() != ::MSU.VanillaID)
		{
			::logError("Register your mod using the same ID with mod_hooks before creating a ::MSU.Class.Mod");
			throw ::MSU.Exception.KeyNotFound(_mod.getID());
		}

		this.addMod(_mod);
	}

	function getMod( _modID )
	{
		if (_modID in this.Mods)
		{
			::logError("Mod " + _modID + " not found in MSU! Did you forget to use ::MSU.registerMod()?");
			throw ::MSU.Exception.KeyNotFound(_modID);
		}
		return this.Mods[_modID];
	}

	function hasMod( _modID )
	{
		return (_modID in this.Mods);
	}
}
