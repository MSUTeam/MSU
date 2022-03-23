::MSU.Class.EmptyModAddon <- class
{
	function _get( _key )
	{
		::logError(::MSU.Error.ModNotRegistered(_key));
		throw ::MSU.Exception.KeyNotFound(_key);
	}
}
