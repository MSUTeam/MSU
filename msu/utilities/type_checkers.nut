this.MSU.requireString <- function( ... )
{
	this.MSU.requireTypeArray("string", vargv);
}

this.MSU.requireInt <- function( ... )
{
	this.MSU.requireTypeArray("integer", vargv);
}

this.MSU.requireArray <- function( ... )
{
	this.MSU.requireTypeArray("array", vargv);
}

this.MSU.requireFloat <- function( ... )
{
	this.MSU.requireTypeArray("float", vargv);
}

this.MSU.requireBool <- function( ... )
{
	this.MSU.requireTypeArray("bool", vargv);
}

this.MSU.requireTable <- function( ... )
{
	this.MSU.requireTypeArray("table", vargv);
}

this.MSU.requireInstance <- function( ... )
{
	this.MSU.requireTypeArray("instance", vargv);
}

this.MSU.requireFunction <- function( ... )
{
	this.MSU.requireTypeArray("function", vargv);
}

this.MSU.requireType <- function( _type, ... )
{
	this.MSU.requireTypeArray(_type, vargv);
}

// Private
this.MSU.requireTypeArray <- function( _type, _values )
{
	foreach (value in _values)
	{
		if (typeof value != _type)
		{
			throw ::MSU.Exception.InvalidType;
		}
	}
}

this.MSU.requireOneOfType <- function( _typeArray, ... )
{
	foreach (value in vargv)
	{
		if (_typeArray.find(typeof value) == null)
		{
			throw ::MSU.Exception.InvalidType;
		}
	}
}
