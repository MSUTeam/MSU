local function getRegisteredModRef( _modID )
{
	foreach (mod in ::mods_getRegisteredMods())
	{
		if (mod.Name == _modID) return mod;
	}
}
local lastRegistered = null;

local mods_registerMod = ::mods_registerMod;
::mods_registerMod = function( _id, _version, _name = null, _extra = null )
{
	lastRegistered = _id;
	if (_extra == null) _extra = {};
	if (typeof _version == "string")
	{
		_extra.SemVer <- ::MSU.SemVer.getTable(_version);
		_version = 2147483647; // 2^31-1 to make sure a semver version is always greater than an int/float one
	}
	else if (typeof _version == "float" || typeof _version == "integer")
	{
		_extra.SemVer <- null;
	}
	else
	{
		::logError("Mod \"" + _id + "\" is using an invalid version format. Mod version must be an integer, float or Semantic Version string.");
		throw ::MSU.Exception.InvalidValue(_version);
	}

	_extra.Dependencies <- [];
	mods_registerMod(_id, _version, _name, _extra);
}

local hooks = getRegisteredModRef("mod_hooks");
hooks.SemVer <- null;
hooks.Dependencies <- [];

local mods_queue = ::mods_queue;
::mods_queue = function( _id, _expressions, _function )
{
	if (_id == null) _id = lastRegistered;
	local mod = getRegisteredModRef(_id);
	if (mod == null)
	{
		::logError("Mod " + _id + " not registered.");
		throw ::MSU.Exception.KeyNotFound(_id);
	}
	if (_expressions != null && _expressions != "")
	{
		if (_id == null) _id = ::MSU.Popup.LastRegistered;
		local expressions = split(_expressions, ",");
		_expressions = "";
		for (local i = 0; i < expressions.len(); ++i)
		{
			local queueRegex = regexp("^([!<>])?(\\w+)(?:\\(([<>]=?|=|!=)?([\\w\\.\\+\\-]+)\\))?$");
			local expression = strip(expressions[i]);
			local capture = queueRegex.capture(expression);
			if (capture == null)
			{
				::logError("Mod \"" + _id + "\" is using an invalid queue expression.");
				throw ::MSU.Exception.InvalidValue(expression);
			}
			expressions[i] = {
				Operator = ::MSU.regexMatch(capture, expression, 1),
				Name = ::MSU.regexMatch(capture, expression, 2),
				VersionOperator = ::MSU.regexMatch(capture, expression, 3),
				Version = ::MSU.regexMatch(capture, expression, 4),
				SemVer = null
			}


			if (::MSU.SemVer.isSemVer(expressions[i].Version))
			{
				expressions[i].SemVer = ::MSU.SemVer.getTable(expressions[i].Version);
				expressions[i].Version = 2147483647;
			}
			else if (expressions[i].Version != null)
			{
				expressions[i].Version = expressions[i].Version.tofloat();
			}

			mod.Dependencies.push(expressions[i])
			_expressions += (expressions[i].Operator == null ? "" : expressions[i].Operator) + expressions[i].Name + ","
			// then we recreate the expression without the version info
			// we do this for both semver and normal dependencies, because normal mod hooks doesn't handle ordering operations with version numbers, but we do
		}
		_expressions = _expressions.slice(0,-1);
	}
	mods_queue(_id, _expressions, _function);
}

local _mods_runQueue = ::_mods_runQueue;
::_mods_runQueue = function()
{
	local errors = "";
	local function compareWithNulls(_version1, _operator, _version2)
	{
		local ret = _version1 == null ? -1 : _version2 == null ? 1 : null;
		if (ret != null) return ::MSU.Utils.operatorCompare(ret, _operator)
		return ::MSU.SemVer.compareVersionWithOperator(_version1, _operator, _version2);
	}

	foreach (mod in ::mods_getRegisteredMods())
	{
		foreach (dependencyTable in mod.Dependencies)
		{
			local dependencyMod = ::mods_getRegisteredMod(dependencyTable.Name);
			// First check mod presence
			if (dependencyTable.Operator == "!")
			{
				if (dependencyMod != null)
				{
					errors += mod.FriendlyName + " is not compatible with " + dependencyMod.FriendlyName + "<br><br>";
					continue; // Incompatible mod present
				}
			}
			else if (dependencyTable.Operator == null)
			{
				if (dependencyMod == null)
				{
					errors +=  mod.FriendlyName + " requires " + dependencyTable.Name + "<br><br>";
					continue; // Required mod missing
				}
			}
			else if (dependencyMod == null)
			{
				continue; // Non-required mod missing
			}

			// Then check version
			if (dependencyTable.Version == null)
			{
				continue; // Doesn't require a specific version
			}
			else if (dependencyTable.SemVer == null && dependencyMod.SemVer == null) // both the mod and the depency are not SemVer
			{
				if(::MSU.Utils.operatorCompare(dependencyMod.Version, dependencyTable.VersionOperator, dependencyTable.Version))
				{
					continue; // Mod hooks comparison successful
				}
				else
				{
					errors += mod.FriendlyName + " requires " + dependencyMod.FriendlyName + " version " + dependencyTable.VersionOperator + dependencyTable.Version + " but version " + dependencyMod.Version + " was found<br><br>";
					continue; // Mod hooks comparison failed
				}
			}
			else if (compareWithNulls(dependencyMod.SemVer, dependencyTable.VersionOperator, dependencyTable.SemVer))
			{
				continue; // SemVer comparison successful
			}
			else
			{
				local tableVersion = dependencyTable.SemVer == null ? dependencyTable.Version : ::MSU.SemVer.getVersionString(dependencyTable.SemVer);
				local modVersion = dependencyMod.SemVer == null ? dependencyMod.Version : ::MSU.SemVer.getVersionString(dependencyMod.SemVer);
				errors += mod.FriendlyName + " requires " + dependencyMod.FriendlyName + " version " + dependencyTable.VersionOperator + tableVersion + " but version " + modVersion + " was found<br><br>";
				continue; // SemVer comparison failed
			}
		}
	}

	if (errors != "")
	{
		::MSU.Popup.showRawText(errors, true);
		throw errors;
	}

	_mods_runQueue();
}