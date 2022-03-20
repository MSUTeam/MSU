::MSU.isNull <- function( _object )
{
	if (_object == null)
	{
		return true;
	}
	if (typeof _object == "instance" && _object instanceof this.WeakTableRef)
	{
		return _object.isNull();
	}
	return false;
}

::MSU.getDeepClone <- function( _object, _exclude = null )
{
	local isArray = false;
	switch (typeof _object)
	{
		case "array":
			isArray = true;
			break;
		case "table":
			break;
		case "instance":
			throw ::MSU.Exception.InvalidType;
		default:
			return _object;
	}

	local ret = isArray ? [] : {};	
	foreach (key, element in _object)
	{
		local skip = false;
		if (_exclude != null)
		{
			::MSU.requireArray(_exclude);
			foreach (t in _exclude)
			{
				switch (t)
				{
					case "array":
					case "table":
					case "string":
					case "integer":
					case "boolean":
					case "float":
						if (typeof element == t) skip = true;
						break;
					default:
						if (this.isKindOf(element, t)) skip = true;
				}
				if (skip) break;
			}
		}
		local val = skip || typeof element == "instance" ? element : ::MSU.getDeepClone(element, _exclude);
		if (isArray) ret.push(val);
		else ret[key] <- val;
	}
	return ret;
}