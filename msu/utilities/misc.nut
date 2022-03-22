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

::MSU.isIn <- function( _key, _object, _chain = false )
{
	local obj = _object;

	switch (typeof obj)
	{
		case "instance":
			if (obj instanceof ::WeakTableRef)
			{
				if (obj.isNull())
				{
					::printError("The table inside the WeakTableRef instance is null");
					throw ::MSU.Exception.KeyNotFound(_key);
				}
				obj = _object.get();
			}
			return _key in obj;

		case "table":
			if (!_chain) return _key in obj;
			else
			{
				while(obj.getdelegate() != null)
				{
					local super = obj.getdelegate();
					if (_key in super) return true;
					obj = super;
				}
			}
			break;

		case "array":
			return _object.find(_key) != null;
			break;

		default:
			throw ::MSU.Exception.InvalidType(_object);
	}
}

::MSU.isKindOf <- function( _object, _className )
{
	local obj = _object;
	if (typeof obj == "instance")
	{
		if (obj instanceof ::WeakTableRef)
		{
			if (obj.isNull())
			{
				::printError("The table inside the WeakTableRef instance is null");
				throw ::MSU.Exception.KeyNotFound(_className);
			}
			obj = obj.get();
		}
		else throw ::MSU.Exception.InvalidType(_object);
	}

	return ::isKindOf(obj, _className);
}
