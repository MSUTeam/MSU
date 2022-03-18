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
			throw ::MSU.Exception.InvalidType;
		}
	}
}

::MSU.requireOneOfType <- function( _typeArray, ... )
{
	foreach (value in vargv)
	{
		if (_typeArray.find(typeof value) == null)
		{
			throw ::MSU.Exception.InvalidType;
		}
	}
}
