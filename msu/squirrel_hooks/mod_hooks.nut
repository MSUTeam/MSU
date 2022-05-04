local function getRegisteredModRef( _modID )
{
	foreach (mod in ::mods_getRegisteredMods())
	{
		if (mod.Name == _modID)
		{
			return mod;
		}
	}
}
local lastRegistered = null;

local mods_registerMod = ::mods_registerMod;
::mods_registerMod = function( _id, _version, _name = null, _extra = null )
{
	lastRegistered = _id;
	if (_extra == null) _extra = {};
	local version;
	if (typeof _version == "string")
	{
		_extra.SemVer <- ::MSU.SemVer.getTable(_version);
		version = 2147483647; // 2^31-1 to make sure a semver version is always greater than an int/float one
	}
	else if (typeof _version == "string" || typeof _version == "integer")
	{
		_extra.SemVer <- null;
	}
	else
	{
		throw "Mod \"" + _id + "\" is using an invalid version format. Mod versions must be ints, floats or semver strings.";
	}

	_extra.SemVerDependencies <- [];
	mods_registerMod(_id, version, _name, _extra);
}

local hooks = getRegisteredModRef("mod_hooks");
hooks.SemVer <- null;
hooks.SemVerDependencies <- [];

local mods_queue = ::mods_queue;
::mods_queue = function( _id, _expressions, _function )
{
	if (_id == null) _id = lastRegistered;
	local mod = getRegisteredModRef(_id);
	if (mod == null)
	{
		local error = "Mod " + _id  + " not registered.";
		throw error;
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
				throw "Mod \"" + _id + "\" is using an invalid queue expression: " + expression;
			}
			expressions[i] = {
				Operator = ::MSU.regexMatch(capture, expression, 1),
				Name = ::MSU.regexMatch(capture, expression, 2),
				VersionOperator = ::MSU.regexMatch(capture, expression, 3),
				Version = ::MSU.regexMatch(capture, expression, 4)
			}


			if (!::MSU.SemVer.isSemVer(expressions[i].Version))
			{
				_expressions += expression + ",";
				continue;
			}

			mod.SemVerDependencies.push({
				Name = expressions[i].Name,
				Operator = expressions[i].Operator,
				VersionOperator = expressions[i].VersionOperator,
				Version = ::MSU.SemVer.getTable(expressions[i].Version)
			});
			// then we recreate the expression without the semver info
			_expressions += (expressions[i].Operator == null ? "" : expressions[i].Operator) + expressions[i].Name + ",";
		}
		_expressions = _expressions.slice(0,-1);
	}
	mods_queue(_id, _expressions, _function);
}

local _mods_runQueue = ::_mods_runQueue;
::_mods_runQueue = function()
{
	local errors = "";
	foreach (mod in ::mods_getRegisteredMods())
	{
		foreach (dep in mod.SemVerDependencies) // stuff only exists in here if it has a semver array
		{
			local depMod = ::mods_getRegisteredMod(dep.Name);
			if (dep.Operator == "!")
			{
				if (depMod != null && ::MSU.Semver.compareWithOperator(depMod.SemVer, dep.VersionOperator, dep.Version))
				{
					errors += "Mod " + mod.Name + " is not compatible with mod " + depMod.Name + " version " + ::MSU.SemVer.getVersionString(depMod.SemVer) + ", requires versions other than " + dep.VersionOperator + ::MSU.SemVer.getVersionString(dep.Version) + ".\n\n";
				}
				continue;
			}
			if (depMod == null || !::MSU.SemVer.compareWithOperator(depMod.SemVer, dep.VersionOperator, dep.Version))
			{
				errors += "Mod " + mod.Name + " is not compatible with mod " + depMod.Name + " version " + ::MSU.SemVer.getVersionString(depMod.SemVer) + ", requires version " + dep.VersionOperator + ::MSU.SemVer.getVersionString(dep.Version) + ".\n\n";
			}
		}
	}
	try
	{
		_mods_runQueue();
	}
	catch (error)
	{
		errors += "\n\n" + error;
	}

	if (errors != "")
	{
		::MSU.Popup.showRawText(errors, true);
		throw errors;
	}
}
