::MSU.Class.DebugModAddon <- class extends ::MSU.Class.SystemModAddon
{
	function setFlags( _flagTable )
	{
		::MSU.System.Debug.setFlags(this.Mod.getID(), _flagTable);
	}

	function setFlag( _flagID, _flagBool )
	{
		::MSU.System.Debug.setFlag(this.Mod.getID(), _flagID, _flagBool);
	}

	function setFullDebug( _bool )
	{
		::MSU.System.Debug.setFullDebugForMod(this.Mod.getID(), _bool);
	}

	function isFullDebug()
	{
		return ::MSU.System.Debug.isFullDebugForMod(this.Mod.getID());
	}

	function isEnabled( _flagID = "default" )
	{
		::MSU.System.Debug.isEnabledForMod(this.Mod.getID(), _flagID);
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
