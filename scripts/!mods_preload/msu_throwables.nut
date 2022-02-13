local gt = this.getroottable();
gt.MSU.defineThrowables <- function ()
{
	gt.Exception <- {
		KeyNotFound = "Key not found",
		NotConnected = "The screen does not have a JSHandle (make sure you connect your screens)",
		AlreadyVisible = "Trying to show already visible screen",
		InvalidType = "The variable is of the wrong type",
		NotSemanticVersion = "Version not formatted according to Semantic Versioning guidelines (see https://semver.org/)",
		DuplicateKey = "Key is already present in this table and the table doesn't handle duplicate keys"
	};

	gt.Error <- {

	}

	gt.MSU.requireString <- function( ... )
	{
		this.MSU.requireTypeArray("string", vargv);
	}

	gt.MSU.requireInt <- function( ... )
	{
		this.MSU.requireTypeArray("integer", vargv);
	}

	gt.MSU.requireArray <- function( ... )
	{
		this.MSU.requireTypeArray("array", vargv);
	}

	gt.MSU.requireFloat <- function( ... )
	{
		this.MSU.requireTypeArray("float", vargv);
	}

	gt.MSU.requireBool <- function( ... )
	{
		this.MSU.requireTypeArray("bool", vargv);
	}

	gt.MSU.requireTable <- function( ... )
	{
		this.MSU.requireTypeArray("table", vargv);
	}

	gt.MSU.requireInstance <- function( ... )
	{
		this.MSU.requireTypeArray("instance", vargv);
	}

	gt.MSU.requireType <- function( _type, ... )
	{
		this.MSU.requireTypeArray(_type, vargv);
	}

	// Private
	gt.MSU.requireTypeArray <- function( _type, _values )
	{
		foreach (value in _values)
		{
			if (typeof value != _type)
			{
				throw this.Exception.InvalidType;
			}
		}
	}
}
