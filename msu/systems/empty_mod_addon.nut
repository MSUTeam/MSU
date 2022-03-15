::MSU.Class.EmptyModAddon <- class
{
	function _get(_key)
	{
		throw ::Exception.ModNotRegistered;
	}
}
