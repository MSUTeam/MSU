::MSU.Class.DebugModAddon <- class extends ::MSU.Class.ModSystemAddon
{
	function setFlags( _flagTable, _flagTableBool = null )
	{
		::MSU.System.Debug.setFlags(this.getID(), _flagTable, _flagTableBool);
	}

	function setFlag( _flagID, _flagBool )
	{
		::MSU.System.Debug.setFlag(this.getID(), _flagID, _flagBool);
	}

	function isEnabledForMod( _flagID = "default" )
	{
		::MSU.System.Debug.isEnabledForMod(this.getID(), _flagID);
	}
}
