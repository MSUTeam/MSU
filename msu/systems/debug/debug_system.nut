::MSU.Class.DebugSystem <- class extends ::MSU.Class.System
{
	Mods = null;
	FullDebug = null;
	static LogType = {
		Info = 1,
		Warning = 2,
		Error = 3
	};
	static DefaultFlag = "default";

	constructor()
	{
		base.constructor(::MSU.SystemID.Log);
		this.Mods = {};
		this.FullDebug = false;
	}

	function registerMod( _mod )
	{
		base.registerMod(_mod);
		if (_mod.getID() in this.Mods)
		{
			throw ::MSU.Exception.DuplicateKey(_mod.getID());
		}

		_mod.Debug = ::MSU.Class.DebugModAddon(_mod);
		this.Mods[_mod.getID()] <- {
		};
		this.setFlag(_mod.getID(), this.DefaultFlag, false);
	}

	function setFlag( _modID, _flagID, _flagBool )
	{
		if (!(_modID in this.Mods))
		{
			::logError(::MSU.Error.ModNotRegistered(_modID));
			throw ::MSU.Exception.KeyNotFound(_modID);
		}
		this.Mods[_modID][_flagID] <- _flagBool;
		if (_flagBool == true)
		{
			if (_modID == ::MSU.ID && _flagID == this.DefaultFlag)
			{
				::MSU.Mod.Debug.printWarning(format("Debug flag '%s' set to true for mod '%s'.", _flagID, _modID), "default");
			}
			else
			{
				::MSU.Mod.Debug.printWarning(format("Debug flag '%s' set to true for mod '%s'.", _flagID, _modID), "debug");
			}
		}
	}

	function setFlags( _modID, _flagTable )
	{
		foreach (flagID, flagBool in _flagTable)
		{
			this.setFlag(_modID, flagID, flagBool);
		}
	}

	function setAllFlags( _modID, _bool)
	{
		foreach (flagID, _ in this.Mods[_modID])
		{
			this.setFlag(_modID, flagID, _bool);
		}
	}

	function isEnabledForMod( _modID, _flagID = "default" )
	{
		if (!(_modID in this.Mods))
		{
			::logError(::MSU.Error.ModNotRegistered(_modID));
			throw ::MSU.Exception.KeyNotFound(_modID);
		}
		if (!(_flagID in this.Mods[_modID]))
		{
			throw ::MSU.Exception.KeyNotFound(_flagID);
		}
		return this.isFullDebug() || this.Mods[_modID][_flagID] == true;
	}

	function isFullDebug()
	{
		return this.FullDebug;
	}

	function setFullDebug( _bool )
	{
		this.FullDebug = _bool;
	}

	function print( _printText, _modID, _logType, _flagID = "default" )
	{
		if (!(_modID in this.Mods))
		{
			::logError(::MSU.Error.ModNotRegistered(_modID));
			throw ::MSU.Exception.KeyNotFound(_modID);
		}

		if (this.isEnabledForMod(_modID, _flagID))
		{
			local src = getstackinfos(3).src.slice(0, -4);
			src = split(src, "/")[split(src, "/").len()-1] + ".nut";
			local string = format("%s::%s -- %s -- %s", _modID, _flagID, src, _printText);
			switch (_logType)
			{
				case this.LogType.Info:
					::logInfo(string);
					return;
				case this.LogType.Warning:
					::logWarning(string);
					return;
				case this.LogType.Error:
					::logError(string);
					return;
				default:
					::logError("No log type defined for this log: " + string);
					throw ::MSU.Exception.KeyNotFound(_logType);
			}
		}
	}
}
