::MSU.Class.DebugModAddon <- class extends ::MSU.Class.SystemModAddon
{
	function setFlags( _flagTable, _flagTableBool = null )
	{
		::MSU.System.Debug.setFlags(this.getID(), _flagTable, _flagTableBool);
	}

	function setFlag( _flagID, _flagBool )
	{
		::MSU.System.Debug.setFlag(this.getID(), _flagID, _flagBool);
	}

	function isEnabled( _flagID = "default" )
	{
		::MSU.System.Debug.isEnabledForMod(this.getID(), _flagID);
	}

	function print( _text, _logType, _flagID = "default" )
	{
		::MSU.System.Debug.print(_text, this.getID(), _logType, _flagID);
	}
}
