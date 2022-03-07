this.MSU.isNull <- function(_obj)
{
	if (_obj == null)
	{
		return true;
	}
	if (typeof _obj == "instance" && _obj instanceof this.WeakTableRef)
	{
		return _obj.isNull();
	}
	return false;
}
