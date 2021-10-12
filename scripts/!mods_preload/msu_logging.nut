local gt = this.getroottable();

gt.MSU.setupLoggingUtils <- function()
{
	this.MSU.Log <- {

		LogType = {
			Info = 1,
			Warning = 2,
			Error = 3
		},

		// maxLen is the maximum length of an array/table whose elements will be displayed
		// maxDepth is the maximum depth at which arrays/tables elements will be displayed
		// advanced allows the ID of the object to be displayed to identify different/identical objects

		function printStackTrace( _maxDepth = 0, _maxLen = 10, _advanced = false )
		{
			local count = 2;
			local string = ""
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
				return string
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

		function setDebugLog( _enabled = false, _name = "default" )
		{
			//keep table of mod names so that you can turn it on and off for specific mods

			if (!("DebugLog" in gt.MSU.Log))
			{
				gt.MSU.Log.DebugLog <- {};
			}

			if (!(_name in gt.MSU.Log.DebugLog))
			{
				gt.MSU.Log.DebugLog[_name] <- false;
			}

			gt.MSU.Log.DebugLog[_name] <- _enabled;

			if (gt.MSU.Log.DebugLog[_name])
			{
				this.logInfo("DebugLog set to true for " + _name);
			}
		}

		function isDebug( _str )
		{
			return (_str in gt.MSU.Log.DebugLog && gt.MSU.Log.DebugLog[_str]);
		}

		function print( _arg, _name, _logType )
		{
			if (!(_name in this.MSU.Log.DebugLog))
			{
				this.logWarning(_name " does not exist in DebugLog");
				return;
			}

			if (this.MSU.Log.DebugLog[_name])
			{
				local src = getstackinfos(3).src.slice(0, -4);
				src = split(src, "/")[split(src, "/").len()-1];
				local string = _name +  ": -- " + src + " -- : " + _arg;
				switch (_logType)
				{
					case this.MSU.Log.LogType.Info:
						this.logInfo(string);
						return;
					case this.MSU.Log.LogType.Warning:
						this.logWarning(string);
						return;
					case this.MSU.Log.LogType.Error:
						this.logError(string);
						return;
					default:
						this.logWarning("No log type defined for this log:");
						this.logInfo(string);
						return;
				}
			}
		}
	}

	::printLog <- function( _arg = "No argument for debug log", _name = "default")
	{
		this.MSU.Log.print(_arg, _name, this.MSU.Log.LogType.Info);
	}

	::printWarning <- function( _arg = "No argument for debug log", _name = "default")
	{
		this.MSU.Log.print(_arg, _name, this.MSU.Log.LogType.Warning);
	}

	::printError <- function( _arg = "No argument for debug log", _name = "default")
	{
		this.MSU.Log.print(_arg, _name, this.MSU.Log.LogType.Error);
	}
}