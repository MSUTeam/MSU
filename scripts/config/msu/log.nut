::MSU.Log <- {
	// maxLen is the maximum length of an array/table whose elements will be displayed
	// maxDepth is the maximum depth at which arrays/tables elements will be displayed
	// advanced allows the ID of the object to be displayed to identify different/identical objects
	function printStackTrace( _maxDepth = 0, _maxLen = 10, _advanced = false )
	{
		local count = 2;
		local string = "<div class=\"stacktrace-container value-container\">";
		while (getstackinfos(count) != null)
		{
			string += "<div class=\"function-container\"><div style=\"color:green;\" class=\"label\">Function:</div><div class=\"value\">"
			local line = getstackinfos(count++);
			if (line.func != "unknown")
			{
				string += line.func;
			}

			string += "-> " + line.src + " : " + line.line + "</div></div><div class=\"function-container\"><div style=\"color:green;\" class=\"label\">Variables:</div><div class=\"valueVar\">";

			local fixCounter = 0;
			foreach (key, value in line.locals)
			{
				if (key == "this" || key == "_release_hook_DO_NOT_delete_it_")
				{
					fixCounter++;
					continue;
				}
				string += this.getLocalString(key, value, _maxLen, _maxDepth, _advanced);
			}

			if (line.locals.len() - fixCounter != 0) string = string.slice(0, string.len() - 2);
			else string += "&nbsp;"
			string += "</div></div>";
		}
		string += "</div>"
		::logInfo(string);
	}

	function printData( _data, _maxDepth = 1, _advanced = false, _maxLenMin = 1 )
	{
		::logInfo(this.formatData(_data, _maxDepth, _advanced, _maxLenMin));
	}

	function formatData( _data, _maxDepth = 1, _advanced = false, _maxLenMin = 1)
	{
		if ((typeof _data == "array" || typeof _data == "table") && _data.len() > _maxLenMin)
		{
			_maxLenMin = _data.len();
		}
		return this.getLocalString("Data", _data, _maxLenMin, _maxDepth, _advanced)
	}

	function getLocalString( _key, _value, _maxLen, _depth, _advanced, _isArray = false )
	{
		local string = "";

		if (!_isArray)
		{
			string += _key + " = ";
		}
		local arrayVsTable = ["{", false, "}"];
		switch (typeof _value)
		{
			case "array":
				arrayVsTable = ["[", true, "]"];
			case "table":
				if (_value.len() <= _maxLen && _depth > 0)
				{
					string += arrayVsTable[0];
					foreach (key2, value2 in _value)
					{
						string += this.getLocalString(key2, value2, _maxLen, _depth - 1, _advanced, arrayVsTable[1]);
					}
					if (_value.len() > 0)
					{
						string = string.slice(0, string.len() - 2);
					}
					string += arrayVsTable[2] + ", ";

					break;
				}
			case "function":
			case "instance":
			case "null":
				if (!_advanced)
				{
					string += ::MSU.String.capitalizeFirst(typeof _value) + ", ";
					break;
				}
			default:
				string += _value + ", ";
		}
		return string;
	}
}
