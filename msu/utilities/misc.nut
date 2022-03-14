this.MSU.isNull <- function( _object )
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
