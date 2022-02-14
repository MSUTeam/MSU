local gt = this.getroottable();

gt.MSU.setupUtils <- function()
{
	gt.MSU.Math <- {
		// returns log2 of _num, floored (as an int)
		function log2int( _num )
		{
			local count = 0;
			while (_num > 1) 
			{
			    _num = _num >> 1;
			    count++;
			}
			return count;
		}

		// Returns the frequency density of _x using normal distribution
		function normalDistDensity(_x, _mean, _stdev)
		{
			local divider = _stdev * sqrt(2 * 3.14);

			local val = exp(-0.5 * pow((_x - _mean)/(_stdev * 1.0), 2)) / divider;

			local valAtMean = 1 / divider;

			return val / valAtMean;
		}

		// Returns the value of the normal distribution at _x
		function normalDist(_x, _mean, _stdev)
		{
			return exp(-0.5 * pow((_x - _mean)/(_stdev * 1.0), 2)) / (_stdev * sqrt(2 * 3.14));			
		}
	};

	gt.MSU.String <- {		
		function capitalizeFirst( _string )
		{
			local first = (_string).slice(0, 1);
			first = first.toupper();
			local second = (_string).slice(1);
			return first + second;
		}

		function replace( _string, _find, _replace )
		{
			local idx = _string.find(_find);
			if (idx != null)
			{
				return _string.slice(0, idx) + _replace + _string.slice(idx + _find.len());
			}
			
			return _string;
		}

		function isInteger( _string )
		{
			foreach (char in _string)
			{
				if (char < 48 || char > 57) return false;
			}
			return true;
		}
	}

	gt.MSU.Array <- {
		function getRandom( _array, _start = 0, _end = 0 )
		{
			_end = _end == 0 ? _array.len() - 1 : _end;
			return _array[this.Math.rand(0 + _start, _end)];
		}

		function shuffle( _array )
		{
		    for (local i = _array.len() - 1; i > 0; i--)
		    {
		        local j = this.Math.rand(0, i);

		        local temp = _array[i];
		        _array[i] = _array[j];
		        _array[j]  = temp;
		    }
		}
	}

	gt.MSU.Debug <- {
		// maxLen is the maximum length of an array/table whose elements will be displayed
		// maxDepth is the maximum depth at which arrays/tables elements will be displayed
		// advanced allows the ID of the object to be displayed to identify different/identical objects
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

		function printData(_data, _maxDepth = 1, _advanced = false){
			local maxLen = 1;
			if(typeof _data == "array" || typeof _data == "table"){
				maxLen = _data.len();
			}
			return this.getLocalString("Printing Data", _data, maxLen, _maxDepth, _advanced)
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
	}
}
