::MSU.Class.DebugModAddon <- class extends ::MSU.Class.SystemModAddon
{
	function enable()
	{
		::MSU.System.Debug.setAllFlags(this.Mod.getID(), true);
	}

	function disable()
	{
		::MSU.System.Debug.setAllFlags(this.Mod.getID(), false);
	}

	function setFlag( _flagID, _flagBool )
	{
		::MSU.System.Debug.setFlag(this.Mod.getID(), _flagID, _flagBool);
	}

	function setFlags( _flagTable )
	{
		::MSU.System.Debug.setFlags(this.Mod.getID(), _flagTable);
	}

	function isEnabled( _flagID = ::MSU.System.Debug.DefaultFlag )
	{
		return ::MSU.System.Debug.isEnabledForMod(this.Mod.getID(), _flagID);
	}

	function printLog( _text, _flagID = ::MSU.System.Debug.DefaultFlag )
	{
		::MSU.System.Debug.print(_text, this.Mod.getID(), ::MSU.System.Debug.LogType.Info, _flagID);
	}

	function printWarning( _text, _flagID = ::MSU.System.Debug.DefaultFlag )
	{
		::MSU.System.Debug.print(_text, this.Mod.getID(), ::MSU.System.Debug.LogType.Warning, _flagID);
	}

	function printError( _text, _flagID = ::MSU.System.Debug.DefaultFlag )
	{
		::MSU.System.Debug.print(_text, this.Mod.getID(), ::MSU.System.Debug.LogType.Error, _flagID);
	}
}
