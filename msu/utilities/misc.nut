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

::MSU.getField <- function( _object, _key )
{
	if (typeof _object == "instance")
	{
		if (_object instanceof ::WeakTableRef)
		{
			if (_object.isNull())
			{
				::printError("The table inside the WeakTableRef instance is null");
				throw ::MSU.Exception.KeyNotFound(_object);
			}
			_object = _object.get();
		}
		else throw ::MSU.Exception.InvalidType(_object);
	}

	_object = _object.m;

	if (_key in _object) return _object[_key];

	do
	{
		_object = _object.getdelegate();
		if (_key in _object) return _object[_key];
	}
	while(_object != null);

	throw ::MSU.Exception.KeyNotFound(_key);
}

::MSU.getMember <- function( _object, _key )
{
	if (typeof _object == "instance")
	{
		if (_object instanceof ::WeakTableRef)
		{
			if (_object.isNull())
			{
				::printError("The table inside the WeakTableRef instance is null");
				throw ::MSU.Exception.KeyNotFound(_object);
			}
			_object = _object.get();
		}
		else throw ::MSU.Exception.InvalidType(_object);
	}

	if (_key in _object) return _object[_key];

	do
	{
		_object = _object.getdelegate();
		if (_key in _object) return _object[_key];
	}
	while(_object != null);

	throw ::MSU.Exception.KeyNotFound(_key);
}

::MSU.isIn <- function( _member, _object, _chain = false )
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
					throw ::MSU.Exception.KeyNotFound(_member);
				}
				obj = _object.get();
			}
			return _member in obj;

		case "table":
			if (!_chain) return _member in obj;
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
			return _object.find(_member) != null;
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
