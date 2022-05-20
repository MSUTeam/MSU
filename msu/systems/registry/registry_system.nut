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
		::logInfo(format("<span style=\"color: green;\">MSU registered <span style=\"color: white;\">%s</span>, version: <span style=\"color: white;\">%s</span></span>", _mod.getName(), _mod.getVersionString()));
	}

	function registerMod( _mod )
	{
		if (_mod.getID() != ::MSU.VanillaID)
		{
			if (_mod.getID() in this.Mods)
			{
				::logError("Duplicate Mod ID for mod: " + _mod.getID());
				throw ::MSU.Exception.DuplicateKey(_mod.getID());
			}
			if (::mods_getRegisteredMod(_mod.getID()) == null)
			{
				::logError("Register your mod using the same ID with mod_hooks before creating a ::MSU.Class.Mod");
				throw ::MSU.Exception.KeyNotFound(_mod.getID());
			}
			if (::mods_getRegisteredMod(_mod.getID()).SemVer == null || ::MSU.SemVer.getVersionString(::mods_getRegisteredMod(_mod.getID()).SemVer) != _mod.getVersionString())
			{
				::logError("Register your mod using the same version with mod_hooks before creating a ::MSU.Class.Mod");
				throw ::MSU.Exception.InvalidValue(_mod.getVersionString());
			}
		}

		this.addMod(_mod);
	}

	function getMod( _modID )
	{
		if (!(_modID in this.Mods))
		{
			::logError("Mod " + _modID + " not found in MSU! Did you forget to create a Mod Object via ::MSU.Class.Mod?");
			throw ::MSU.Exception.KeyNotFound(_modID);
		}
		return this.Mods[_modID];
	}

	function hasMod( _modID )
	{
		return (_modID in this.Mods);
	}
}
