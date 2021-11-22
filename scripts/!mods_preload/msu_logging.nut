local gt = this.getroottable();

gt.MSU.setupDebuggingUtils <- function(_msuModName)
{
	this.MSU.Debug <- {
		ModTable = {},
		LogType = {
			Info = 1,
			Warning = 2,
			Error = 3
		},
		DefaultFlag = "default",
		VanillaLogName = "vanilla",
		MSUModName = _msuModName,

		// maxLen is the maximum length of an array/table whose elements will be displayed
		// maxDepth is the maximum depth at which arrays/tables elements will be displayed
		// advanced allows the ID of the object to be displayed to identify different/identical objects


		function registerMod(_modID, _defaultFlagValue = false, _flagIDTable = null, _flagIDTableValue = null)
		{
			if (_modID in this.ModTable)
			{
				this.logError(format("Mod %s already exists in the debug log table!"), _modID);
				return;
			}
			this.ModTable[_modID] <- {};
			this.setFlagValue(_modID, this.DefaultFlag, _defaultFlagValue);

			if (_flagIDTable != null)
			{
				this.setFlagValues(_modID, _flagIDTable, _flagIDTableValue);
			}
		}

		function setFlagValues(_modID, _flagIDTable, _flagIDTableValue = null)
		{
			foreach(flagID, flagValue in _flagIDTable)
			{
				this.setFlagValue(_modID, flagID, _flagIDTableValue != null ? _flagIDTableValue : flagValue);
			}
		}

		function setFlagValue(_modID, _flagID, _flagValue)
		{
			if (!(_modID in this.ModTable))
			{
				::printWarning(format("Mod '%s' does not exist in the debug log table! Please initialise using setupMod()."), _modID, this.MSUModName, "debug");
				return;
			}
			this.ModTable[_modID][_flagID] <- _flagValue;
			if (_flagValue == true)
			{
				if (_modID == this.MSUModName)
				{
					this.logInfo(format("Debug flag '%s' set to true for mod '%s'.", _flagID, _modID));
				}
				else
				{
					::printLog(format("Debug flag '%s' set to true for mod '%s'.", _flagID, _modID), this.MSUModName, "debug");
				}
			}
		}


		function isEnabledForMod( _modID, _flagID = null)
		{
			if (!(_modID in this.ModTable))
			{
				::printWarning(format("Mod '%s' not found in debug table!", _modID), this.MSUModName, "debug");
				return false;
			}
			if (_flagID == null)
			{
				_flagID = this.DefaultFlag;
			}
			if (!(_flagID in this.ModTable[_modID]))
			{
				::printWarning(format("Flag '%s' not found in mod '%s'! ", _flagID, _modID), this.MSUModName, "debug");
				return false;
			}

			return this.ModTable[_modID][_flagID] == true;
		}

		function printStackTrace( _maxDepth = 0, _maxLen = 10, _advanced = false )
		{
			local count = 2;
			local string = "";
			while (getstackinfos(count) != null)
			{
				local line = getstackinfos(count++);
				string += "Function:\t\t";

				if (line.func != "unknown")
				{
					string += line.func + " ";
				}

				string += "-> " + line.src + " : " + line.line + "\nVariables:\t\t";

				foreach (key, value in line.locals)
				{
					string += this.getLocalString(key, value, _maxLen, _maxDepth, _advanced);
				}
				string = string.slice(0, string.len() - 2);
				string += "\n";
			}
			this.logInfo(string);
		}

		function getLocalString( _key, _value, _maxLen, _depth, _advanced, _isArray = false )
		{
			local string = "";

			if (_key == "this" || _key == "_release_hook_DO_NOT_delete_it_")
			{
				return string;
			}

			if (!_isArray)
			{
				string += _key + " = ";
			}
			local arrayVsTable = ["{", false, "}"];
			switch (typeof _value)
			{
				case "array":
					arrayVsTable = ["[", true, "]"]
				case "table":
					if (_value.len() <= _maxLen && _depth > 0)
					{
						string += arrayVsTable[0];
						foreach (key2, value2 in _value)
						{
							string += this.getLocalString(key2, value2, _maxLen, _depth - 1, _advanced, arrayVsTable[1]);
						}
						string = string.slice(0, string.len() - 2) + arrayVsTable[2] + ", ";
						break;
					}
				case "function":
				case "instance":
				case "null":
					if (!_advanced)
					{
						string += this.MSU.String.capitalizeFirst(typeof _value) + ", ";
						break;
					}
				default:
					string += _value + ", ";
			}
			return string;
		}

		function print( _arg, _modID, _logType, _flagID = null)
		{
			if (!(_modID in this.ModTable))
			{
				this.printWarning(format("Mod '%s' not registered in debug logging! Call this.registerMod().", _modID), this.MSUModName, "debug");
				return;
			}
			if (_flagID == null)
			{
				_flagID = this.DefaultFlag;
			}

			if (this.isEnabledForMod(_modID, _flagID))
			{
				local src = getstackinfos(3).src.slice(0, -4);
				src = split(src, "/")[split(src, "/").len()-1] + ".nut";
				local string = format("%s::%s -- %s -- %s", _modID, _flagID, src, _arg);
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
						this.printWarning("No log type defined for this log:", this.MSUModName, "debug");
						this.logInfo(string);
						return;
				}
			}
		}

		MSUDebugFlags = {
			debug = true,
			movement = true,
			skills = false,
		}
	}

	::printLog <- function( _arg, _modID, _flagID = null)
	{
		this.MSU.Debug.print(_arg, _modID, this.MSU.Debug.LogType.Info, _flagID);
	}

	::printWarning <- function( _arg,  _modID, _flagID = null)
	{
		this.MSU.Debug.print(_arg, _modID, this.MSU.Debug.LogType.Warning, _flagID);
	}

	::printError <- function( _arg,  _modID, _flagID = null)
	{
		this.MSU.Debug.print(_arg, _modID, this.MSU.Debug.LogType.Error, _flagID);
	}

	this.MSU.Debug.registerMod(this.MSU.Debug.MSUModName, true, this.MSU.Debug.MSUDebugFlags);
	this.MSU.Debug.registerMod(this.MSU.Debug.VanillaLogName, true);
}