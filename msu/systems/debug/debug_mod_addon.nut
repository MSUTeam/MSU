::MSU.Class.DebugModAddon <- class extends ::MSU.Class.SystemModAddon
{
	function setFlags( _flagTable, _flagTableBool = null )
	{
		::MSU.System.Debug.setFlags(this.Mod.getID(), _flagTable, _flagTableBool);
	}

	function setFlag( _flagID, _flagBool )
	{
		::MSU.System.Debug.setFlag(this.Mod.getID(), _flagID, _flagBool);
	}

	function isEnabled( _flagID = "default" )
	{
		::MSU.System.Debug.isEnabledForMod(this.Mod.getID(), _flagID);
	}

	function print( _text, _logType, _flagID = "default" )
	{
		::MSU.System.Debug.print(_text, this.Mod.getID(), _logType, _flagID);
	}

	function printLog( _text, _flagID = ::MSU.System.Debug.DefaultFlag )
	{
		this.print(_text, ::MSU.System.Debug.LogType.Info, _flagID)
	}

	function printWarning( _text, _flagID = ::MSU.System.Debug.DefaultFlag )
	{
		this.print(_text, ::MSU.System.Debug.LogType.Warning, _flagID);
	}

	function printError( _text, _flagID = ::MSU.System.Debug.DefaultFlag )
	{
		this.print(_text, ::MSU.System.Debug.LogType.Error, _flagID);
	}
}
