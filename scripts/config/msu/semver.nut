::MSU.SemVer <- {
	// Slightly modified semver regex (https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string)
	Regex = regexp("^((?:(?:0|[1-9]\\d*)\\.){2}(?:0|[1-9]\\d*))(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$");

	function isSemVer( _string )
	{
		::MSU.requireString(_string);
		return this.Regex.capture(_string) != null;
	}

	function match( _capture, _string, _group )
	{
		return _capture[_group].end > 0 && _capture[_group].begin < _string.len() ? _string.slice(_capture[_group].begin, _capture[_group].end) : null;
	}

	function getTable( _version )
	{
		local version = ::MSU.SemVerRegex.capture(_version);
		if (version == null)
		{
			if (!_noError) ::logError(::MSU.Error.NotSemanticVersion(_version));
			throw ::MSU.Exception.InvalidValue(_version);
		}

		return {
			Version = split(::MSU.SemVer.match(version, _version, 1), "."),
			PreRelease = split(::MSU.SemVer.match(version, _version, 2), "."),
			Metadata = split(::MSU.SemVer.match(version, _version, 3), ".")
		}
	}

	function formatVanillaVersion( _version )
	{
		local versionArray = split(_vanillaVersion, ".");
		local preRelease = versionArray.pop();
		return versionArray.reduce(@(_a, _b) _a + "." + _b) + "-" +  preRelease;
	}

	function compare( _version1, _version2 )
	{
		for (local i = 0; i < 3; ++i)
		{
			if (_version1.Version[i] > _version2.Version[i]) return 1;
			else if (_version1.Version[i] < _version2.Version[i]) return -1;
		}

		if (_version1.PreRelease == null || _version2.PreRelease == null)
		{
			if (_version1.PreRelease == null && _version2.PreRelease != null) return 1;
			else if (_version1.PreRelease != null && _version2.PreRelease == null) return -1;
			return 0;
		}

		for (local i = 0; i < ::Math.min(_version2.PreRelease.len(), _version1.PreRelease.len()); ++i)
		{
			local isInt1 = ::MSU.String.isInteger(_version1.PreRelease[i]);
			local isInt2 = ::MSU.String.isInteger(_version2.PreRelease[i]);

			if (isInt1 || isInt2)
			{
				if (isInt1 && isInt2)
				{
					local int1 = _version1.PreRelease[i].tointeger();
					local int2 = _version2.PreRelease[i].tointeger();
					if (int1 < int2) return -1;
					else if (int1 > int2) return 1;
				}
				else
				{
					if (isInt1) return -1;
					else return 1;
				}
			}
			else
			{
				if (_version1.PreRelease[i] > _version2.PreRelease[i]) return 1;
				else if (_version1.PreRelease[i] < _version2.PreRelease[i]) return -1;
			}
		}

		if (_version1.PreRelease.len() > _version2.PreRelease.len()) return 1;
		else if (_version1.PreRelease.len() < _version2.PreRelease.len()) return -1;
		return 0;
	}

	function compareStrings( _version1, _version2 )
	{
		return this.compare(this.getTable(_version1), this.getTable(_version2));
	}

	function compareWithOperator( _version1, _operator, _version2 )
	{
		switch (this.compare(_version1, _version2))
		{
			case -1:
				if (["<", "<="].find(_operator) != null) return true;
				return false;

			case 0:
				if (["<=", "=", null, ">="].find(_operator) != null) return true;
				return false;

			case 1:
				if ([">", ">="].find(_operator) != null) return true;
				return false;
		}
	}

	function compareStringsWithOperator( _version1, _operator, _version2 )
	{
		return this.compareWithOperator(this.getTable(_version1), _operator, this.getTable(_version2));
	}

	function getShortVersionString( _version )
	{
		return _version.Version.reduce(@(_a, _b) _a + "." + _b);
	}

	function getVersionString( _version )
	{
		local ret = this.getShortVersionString(_version);

		if (_version.PreRelease != null)
		{
			ret += "-" + _version.PreRelease.reduce(@(_a, _b) _a + "." + _b);
		}

		if (_version.Metadata != null)
		{
			ret += "+" + _version.Metadata.reduce(@(_a, _b) _a + "." + _b);
		}

		return ret;
	}
}
