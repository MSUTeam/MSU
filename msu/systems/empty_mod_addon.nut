::MSU.Class.EmptyModAddon <- class
{
	function _get( _key )
	{
		throw ::MSU.Exception.ModNotRegistered();
	}
}
