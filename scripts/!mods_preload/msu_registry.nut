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
		Options = null;

		constructor( _id, _version, _options = null, _name = null )
		{
			if (_name == null) _name = _id;
			this.MSU.requireString(_id, _version, _name);
			if (_options == null) _options == [];
			this.MSU.requireArray(_options);
			foreach (value in _options)
			{
				local found = false;
				foreach (system in this.MSU.Systems)
				{
					if (system.getID() == value)
					{
						found = true;
						break;
					}
				}
				if (!found)
				{
					throw this.Exception.KeyNotFound;
				}
			}

			this.ID = _id;
			this.Name = _name;
			this.Options = _options;

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

		function compareToVersionString( _version )
		{
			local dummy = this.MSU.Class.Mod("dummy", _version);
			return dummy <=> this;
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
			this.Mods = []
		}

		function registerMod( _modID, _version, _options = null, _modName = null )
		{
			if (_modID in this.MSU.Mods)
			{
				this.logError("Duplicate Mod ID for mod: " + _modID);
				throw this.Exception.DuplicateKey;
			}

			local mod = this.MSU.Class.Mod(_modID, _version, _options, _modName);
			this.Mods[_modID] <- mod;
			::printLog("MSU registered mod " + mod.getName() + ", version: " + mod.getVersionString(), this.MSUModName)

			foreach (system in this.MSU.Systems)
			{
				if (system instanceof this.MSU.Class.RequiredModSystem)
				{
					system.onModRegistered(mod);
				}
			}
		}
	}

	local system = this.MSU.Class.ModRegistrySystem();

	this.MSU.Systems.ModRegistry <- system;
	this.MSU.Mods <- system.Mods;
	this.MSU.registerMod <- system.registerMod;
}
