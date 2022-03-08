::includeFile("msu/systems/debug/", "debug_system.nut");

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

this.MSU.System.Debug.registerMod(this.MSU.ID, true);

//need to set this first to print the others
this.MSU.System.Debug.setFlags(this.MSU.ID, this.MSU.System.Debug.MSUMainDebugFlag);

this.MSU.System.Debug.setFlags(this.MSU.ID, this.MSU.System.Debug.MSUDebugFlags);

this.MSU.System.Debug.registerMod(this.MSU.VanillaID, true);
