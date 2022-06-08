::MSU.requireString <- function( ... )
{
	::MSU.requireTypeArray("string", vargv);
}

::MSU.requireInt <- function( ... )
{
	::MSU.requireTypeArray("integer", vargv);
}

::MSU.requireArray <- function( ... )
{
	::MSU.requireTypeArray("array", vargv);
}

::MSU.requireFloat <- function( ... )
{
	::MSU.requireTypeArray("float", vargv);
}

::MSU.requireBool <- function( ... )
{
	::MSU.requireTypeArray("bool", vargv);
}

::MSU.requireTable <- function( ... )
{
	::MSU.requireTypeArray("table", vargv);
}

::MSU.requireInstance <- function( ... )
{
	::MSU.requireTypeArray("instance", vargv);
}

::MSU.requireInstanceOf <- function( _class, ... )
{
	foreach (value in vargv)
	{
		if (typeof value != "instance" || !(value instanceof _class))
		{
			::logError(format("%s must be an instance of the class %s.", value, _class));
			throw ::MSU.Exception.InvalidType(value);
		}
	}
}

::MSU.requireFunction <- function( ... )
{
	::MSU.requireTypeArray("function", vargv);
}

::MSU.requireType <- function( _type, ... )
{
	::MSU.requireTypeArray(_type, vargv);
}

// Private
::MSU.requireTypeArray <- function( _type, _values )
{
	foreach (value in _values)
	{
		if (typeof value != _type)
		{
			::logError(format("%s must have the type: %s.", value, _type));
			throw ::MSU.Exception.InvalidType(value);
		}
	}
}

::MSU.requireOneFromTypes <- function( _typeArray, ... )
{
	foreach (value in vargv)
	{
		if (_typeArray.find(typeof value) == null)
		{
			::logError(format("%s must have one of the types: %s.", value, _typeArray.reduce(@(a, b) format("%s, %s", a, b))));
			throw ::MSU.Exception.InvalidType(value);
		}
	}
}

::MSU.requireAnyTypeExcept <- function( _typeArray, ... )
{
	foreach (value in vargv)
	{
		if (_typeArray.find(typeof value) != null)
		{
			::logError(format("%s must NOT be one of the types: %s.", value, _typeArray.reduce(@(a, b) format("%s, %s", a, b))));
			throw ::MSU.Exception.InvalidType(value);
		}
	}
}
