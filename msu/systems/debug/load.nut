::includeFile("msu/systems/debug/", "debug_system.nut");
::includeFile("msu/systems/debug/", "debug_mod_addon.nut");

this.MSU.System.Debug <- this.MSU.Class.DebugSystem();

::printLog <- function( _arg, _modID, _flagID = this.MSU.System.Debug.DefaultFlag)
{
	this.MSU.System.Debug.print(_arg, _modID, this.MSU.System.Debug.LogType.Info, _flagID);
}

::printWarning <- function( _arg,  _modID, _flagID = this.MSU.System.Debug.DefaultFlag)
{
	this.MSU.System.Debug.print(_arg, _modID, this.MSU.System.Debug.LogType.Warning, _flagID);
}

::printError <- function( _arg,  _modID, _flagID = this.MSU.System.Debug.DefaultFlag)
{
	this.MSU.System.Debug.print(_arg, _modID, this.MSU.System.Debug.LogType.Error, _flagID);
}

::isDebugEnabled <- function(_modID, _flagID = this.MSU.System.Debug.DefaultFlag)
{
	return this.MSU.System.Debug.isEnabledForMod( _modID, _flagID)
}

// The above need to get removed


