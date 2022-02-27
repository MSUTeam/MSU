this.MSU.Class.DebugSystem <- class extends this.MSU.Class.System
{
	ModTable = null;
	LogType = null;
	FullDebug = null;
	DefaultFlag = null;
	VanillaLogName = null;
	MSUMainDebugFlag = null;
	MSUDebugFlags = null;

	constructor()
	{
		base.constructor(this.MSU.SystemIDs.Log);
		this.ModTable = {};
		this.LogType = {
			Info = 1,
			Warning = 2,
			Error = 3
		};
		this.FullDebug = false;
		this.DefaultFlag = "default";
		this.VanillaLogName = "vanilla";

		this.MSUMainDebugFlag = {
			debug = true
		}
		this.MSUDebugFlags = {
			movement = true,
			skills = false,
			keybinds = false,
			persistence = true
		}
	}

	function registerMod( _modID, _defaultFlagBool = false, _flagTable = null, _flagTableBool = null )
	{
		base.registerMod(_modID);
		if (_modID in this.ModTable)
		{
			this.logError(format("Mod %s already exists in the debug log table!"), _modID);
			throw this.Exception.DuplicateKey;
		}

		this.ModTable[_modID] <- {};
		this.setFlag(_modID, this.DefaultFlag, _defaultFlagBool);

		if (_flagTable != null)
		{
			this.setFlags(_modID, _flagTable, _flagTableBool);
		}
	}

	function setFlags(_modID, _flagTable, _flagTableBool = null)
	{
		foreach (flagID, flagBool in _flagTable)
		{
			this.setFlag(_modID, flagID, _flagTableBool != null ? _flagTableBool : flagBool);
		}
	}

	function setFlag(_modID, _flagID, _flagBool)
	{
		if (!(_modID in this.ModTable))
		{
			::printWarning(format("Mod '%s' does not exist in the debug log table! Please initialise using registerMod().", _modID), this.MSU.MSUModName);
			return;
		}
		this.ModTable[_modID][_flagID] <- _flagBool;
		if (_flagBool == true)
		{
			if (_modID == this.MSU.MSUModName && _flagID == this.DefaultFlag)
			{
				this.logInfo(format("Debug flag '%s' set to true for mod '%s'.", _flagID, _modID));
			}
			else
			{
				if (this.isEnabledForMod(this.MSU.MSUModName, "debug")){
					::printWarning(format("Debug flag '%s' set to true for mod '%s'.", _flagID, _modID), this.MSU.MSUModName, "debug");
				}
			}
		}
	}

	function isEnabledForMod( _modID, _flagID = "default")
	{
		if (!(_modID in this.ModTable))
		{
			//circumvent infinite loop if MSU flag is somehow missing
			if (("debug" in this.ModTable[this.MSU.MSUModName] && this.ModTable[this.MSU.MSUModName]["debug" ] == true)  || this.isFullDebug()){
				::printWarning(format("Mod '%s' not found in debug table!", _modID), this.MSU.MSUModName, "debug");
			}
			return false;
		}
		if (!(_flagID in this.ModTable[_modID]))
		{
			//circumvent infinite loop if MSU flag is somehow missing
			if (("debug" in this.ModTable[this.MSU.MSUModName] && this.ModTable[this.MSU.MSUModName]["debug" ] == true)  || this.isFullDebug()){
				::printWarning(format("Flag '%s' not found in mod '%s'! ", _flagID, _modID), this.MSU.MSUModName, "debug");
			}
			return false;
		}

		return (this.ModTable[_modID][_flagID] == true) || this.isFullDebug();
	}

	function isFullDebug()
	{
		return this.FullDebug;
	}

	function setFullDebug(_bool)
	{
		this.FullDebug = _bool;
	}

	function print( _printText, _modID, _logType, _flagID = "default")
	{
		if (!(_modID in this.ModTable))
		{
			if (this.isEnabledForMod(this.MSU.MSUModName, "debug")){
				this.printWarning(format("Mod '%s' not registered in debug logging! Call this.registerMod().", _modID), this.MSU.MSUModName, "debug");
			}
			return;
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
					this.printWarning("No log type defined for this log:", this.MSU.MSUModName, "debug");
					this.logInfo(string);
					return;
			}
		}
	}
}