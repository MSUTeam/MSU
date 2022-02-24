local gt = this.getroottable();

gt.MSU.setupModRegistry <- function()
{

	this.MSU.Class.Mod <- class
	{
		ID = null;
		Name = null;
		Version = null;
		PreRelease = null;
		Metadata = null;

		constructor( _id, _version, _name = null )
		{
			if (_name == null) _name = _id;
			this.MSU.requireString(_id, _version, _name);

			this.ID = _id;
			this.Name = _name;

			local table = this.getVersionTable(_version);
			this.Version = table.Version;
			this.PreRelease = table.PreRelease;
			this.Metadata = table.Metadata;
		}

		function getName()
		{
			return this.Name;
		}

		function getID()
		{
			return this.ID;
		}

		// Private
		function getVersionTable( _version )
		{
			local version = split(_version, "+");
			if (version.len() > 2)
			{
				throw this.Exception.NotSemanticVersion;
			}
			local metadata = version.len() == 2 ? version[1] : null;
			version = split(version[0], "-");

			if (version.len() > 2)
			{
				throw this.Exception.NotSemanticVersion;
			}

			local prerelease = version.len() == 2 ? version[1] : null;
			version = split(version[0], ".");

			if (version.len() > 3)
			{
				throw this.Exception.NotSemanticVersion;
			}
			else if (version.len() < 3)
			{
				version.extend(array(3 - version.len(), "0"))
			}

			try
			{
				for (local i = 0; i < version.len(); ++i)
				{
					if (!this.MSU.String.isInteger(version[i]))
					{
						throw this.Exception.NotSemanticVersion;
					}
					version[i] = version[i].tointeger();
				}
			}
			catch (error)
			{
				throw this.Exception.NotSemanticVersion;
			}

			local ret = {
				Metadata = null,
				PreRelease = null,
				Version = version
			}

			if (metadata != null)
			{
				ret.Metadata = split(metadata, ".");
			}

			if (prerelease != null)
			{
				ret.PreRelease = split(prerelease, ".");
			}

			return ret;
		}

		function getShortVersionString()
		{
			local ret = "";
			foreach (value in this.Version)
			{
				ret += value + ".";
			}
			ret = ret.slice(0, ret.len() - 1);
			return ret;
		}

		function getVersionString()
		{
			local ret = this.getShortVersionString();

			if (this.PreRelease != null)
			{
				ret = ret + "-";
				foreach (value in this.PreRelease)
				{
					ret += value + ".";
				}
				ret = ret.slice(0, ret.len() - 1);
			}

			if (this.Metadata != null)
			{
				ret = ret + "+";
				foreach (value in this.Metadata)
				{
					ret += value + ".";
				}
				ret = ret.slice(0, ret.len() - 1);
			}

			return ret;
		}

		function compareVersion( _version )
		{
			switch (typeof _version)
			{
				case "string":
					local dummy = this.MSU.Class.Mod("dummy", _version);
					return dummy <=> this;
				case "instance":
					if (_version instanceof this.MSU.Class.Mod)
					{
						return _version <=> this;
					}
				default:
					throw this.Exception.InvalidType;
			}
		}

		function _cmp( _mod )
		{
			for (local i = 0; i < 3; ++i)
			{
				if (this.Version[i] > _mod.Version[i])
				{
					return 1;
				}
				else if (this.Version[i] < _mod.Version[i])
				{
					return -1;
				}
			}

			if (this.PreRelease == null || _mod.PreRelease == null)
			{
				if (this.PreRelease == null && _mod.PreRelease != null)
				{
					return 1;
				}
				if (this.PreRelease != null && _mod.PreRelease == null)
				{
					return -1;
				}
				return 0;
			}

			for (local i = 0; i < this.Math.min(_mod.PreRelease.len(), this.PreRelease.len()); ++i)
			{
				local isInt1 = this.MSU.String.isInteger(this.PreRelease[i]);
				local isInt2 = this.MSU.String.isInteger(_mod.PreRelease[i]);

				if (isInt1 || isInt2)
				{
					if (isInt1 && isInt2)
					{
						local int1 = this.PreRelease[i].tointeger();
						local int2 = _mod.PreRelease[i].tointeger();
						if (int1 < int2)
						{
							return -1;
						}
						else if (int1 > int2)
						{
							return 1;
						}
					}
					else
					{
						if (isInt1)
						{
							return -1;
						}
						else
						{
							return 1;
						}
					}
				}
				else
				{
					if (this.PreRelease[i] > _mod.PreRelease[i])
					{
						return 1;
					}
					else if (this.PreRelease[i] < _mod.PreRelease[i])
					{
						return -1;
					}
				}
			}

			if (this.PreRelease.len() > _mod.PreRelease.len())
			{
				return 1;
			}
			else if (this.PreRelease.len() < _mod.PreRelease.len())
			{
				return -1;
			}
			return 0;
		}
	}

	this.MSU.Class.ModRegistrySystem <- class extends this.MSU.Class.System
	{
		Mods = null;
		constructor()
		{
			base.constructor(this.MSU.SystemIDs.ModRegistry);
			this.Mods = {}

			local mod = this.MSU.Class.Mod("vanilla", "1.4.0+48", "Vanilla");
			this.Mods[mod.getID()] <- mod;
			this.logInfo(format("MSU registered %s, version: %s", mod.getName(), mod.getVersionString()))
;		}

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

	local system = this.MSU.Class.ModRegistrySystem();

	this.MSU.Systems.ModRegistry <- system;
	this.MSU.Mods <- system.Mods;
	this.MSU.registerMod <- system.registerMod;
}
