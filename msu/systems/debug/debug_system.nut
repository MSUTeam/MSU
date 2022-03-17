this.MSU.Class.DebugSystem <- class extends this.MSU.Class.System
{
	Mods = null;
	LogType = null;
	FullDebug = null;
	DefaultFlag = null;
	MSUMainDebugFlag = null;
	MSUDebugFlags = null;

	constructor()
	{
		base.constructor(this.MSU.SystemID.Log);
		this.Mods = {};
		this.LogType = {
			Info = 1,
			Warning = 2,
			Error = 3
		};
		this.FullDebug = false;
		this.DefaultFlag = "default";

		this.MSUMainDebugFlag = {
			debug = true
		}
		this.MSUDebugFlags = {
			movement = false,
			skills = false,
			keybinds = true,
			persistence = true
		}
	}

	function registerMod( _mod, _defaultFlagBool = false, _flagTable = null)
	{
		base.registerMod(_mod);
		if (_mod.getID() in this.Mods)
		{
			throw ::MSU.Exception.DuplicateKey;
		}

		_mod.Debug = ::MSU.Class.DebugModAddon(_mod);
		this.Mods[_mod.getID()] <- {
			FullDebug = false,
		};
		this.setFlag(_mod.getID(), this.DefaultFlag, _defaultFlagBool);

		if (_flagTable != null)
		{
			this.setFlags(_mod.getID(), _flagTable, _flagTableBool);
		}
	}

	function setFlags(_modID, _flagTable)
	{
		foreach (flagID, flagBool in _flagTable)
		{
			this.setFlag(_modID, flagID, flagBool);
		}
	}

	function setFlag(_modID, _flagID, _flagBool)
	{
		if (!(_modID in this.Mods))
		{
			throw ::MSU.Exception.ModNotRegistered
		}
		this.Mods[_modID][_flagID] <- _flagBool;
		if (_flagBool == true)
		{
			if (_modID == this.MSU.ID && _flagID == this.DefaultFlag)
			{
				::MSU.Mod.Debug.printWarning(format("Debug flag '%s' set to true for mod '%s'.", _flagID, _modID), "default");
			}
			else
			{
				::MSU.Mod.Debug.printWarning(format("Debug flag '%s' set to true for mod '%s'.", _flagID, _modID), "debug");
			}
		}
	}

	function isEnabledForMod( _modID, _flagID = "default")
	{
		if (!(_modID in this.Mods))
		{
			throw ::MSU.Exception.KeyNotFound;
		}
		if (!(_flagID in this.Mods[_modID]))
		{
			throw ::MSU.Exception.KeyNotFound;
		}
		return  this.isFullDebug() || this.isFullDebugForMod(_modID) || this.Mods[_modID][_flagID] == true;
	}

	function isFullDebug()
	{
		return this.FullDebug;
	}

	function setFullDebug(_bool)
	{
		this.FullDebug = _bool;
	}

	function setFullDebugForMod( _modID, _bool )
	{
		this.Mods[_modID].FullDebug = _bool;
	}

	function isFullDebugForMod( _modID )
	{
		return this.Mods[_modID].FullDebug;
	}

	function print( _printText, _modID, _logType, _flagID = "default")
	{
		if (!(_modID in this.Mods))
		{
			throw ::MSU.Exception.ModNotRegistered
		}

		if (this.isEnabledForMod(_modID, _flagID))
		{
			local src = getstackinfos(3).src.slice(0, -4);
			src = split(src, "/")[split(src, "/").len()-1] + ".nut";
			local string = format("%s::%s -- %s -- %s", _modID, _flagID, src, _printText);
			switch (_logType)
			{
				case this.LogType.Info:
					this.logInfo(string);
					return;
				case this.LogType.Warning:
					this.logWarning(string);
					return;
				case this.LogType.Error:
					this.logError(string);
					return;
				default:
					this.printWarning("No log type defined for this log:", this.MSU.ID, "debug");
					this.logInfo(string);
					return;
			}
		}
	}
}
