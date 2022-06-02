::MSU.isNull <- function( _object )
{
	return _object == null || (typeof _object == "instance" && _object instanceof ::WeakTableRef && _object.isNull());
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

	do
	{
		if (_key in _object) return _object[_key];
		_object = _object.getdelegate();
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

	do
	{
		if (_key in _object) return _object[_key];
		_object = _object.getdelegate();
	}
	while(_object != null);

	throw ::MSU.Exception.KeyNotFound(_key);
}

::MSU.isIn <- function( _member, _object, _chain = false )
{
	if (_object == null) return false;
	switch (typeof _object)
	{
		case "instance":
			if (!(_object instanceof ::WeakTableRef)) return _member in _object;
			if (_object.isNull()) return false;
			_object = _object.get();
		case "table":
			if (!_chain) return _member in _object;
			do
			{
				if (_member in _object) return true;
				_object = _object.getdelegate();
			}
			while(_object != null);
			return false;

		case "array":
			return _object.find(_member) != null;

		default:
			return false;
	}

	return false;
}

::MSU.isKindOf <- function( _object, _className )
{
	if (_object == null || _className == null) return false;
	if (typeof _object == "instance" && _object instanceof ::WeakTableRef)
	{
		if (_object.isNull()) return false;
		_object = _object.get();
	}

	return ::isKindOf(_object, _className);
}

::MSU.asWeakTableRef <- function( _object )
{
	if (typeof _object == "instance")
	{
		if (_object instanceof ::WeakTableRef) return _object;
		throw ::MSU.Exception.InvalidType(_object);
	}
	return ::WeakTableRef(_object);
}

::MSU.regexMatch <- function( _capture, _string, _group )
{
	return _capture[_group].end > 0 && _capture[_group].begin < _string.len() ? _string.slice(_capture[_group].begin, _capture[_group].end) : null;
}
