this.MSU.Systems.Debug <- this.MSU.Class.DebugSystem();

::printLog <- function( _arg, _modID, _flagID = this.MSU.Systems.Debug.DefaultFlag)
{
	this.MSU.Systems.Debug.print(_arg, _modID, this.MSU.Systems.Debug.LogType.Info, _flagID);
}

::printWarning <- function( _arg,  _modID, _flagID = this.MSU.Systems.Debug.DefaultFlag)
{
	this.MSU.Systems.Debug.print(_arg, _modID, this.MSU.Systems.Debug.LogType.Warning, _flagID);
}

::printError <- function( _arg,  _modID, _flagID = this.MSU.Systems.Debug.DefaultFlag)
{
	this.MSU.Systems.Debug.print(_arg, _modID, this.MSU.Systems.Debug.LogType.Error, _flagID);
}

::isDebugEnabled <- function(_modID, _flagID = this.MSU.Systems.Debug.DefaultFlag){
	return this.MSU.Systems.Debug.isEnabledForMod( _modID, _flagID)
}

this.MSU.Systems.Debug.registerMod(this.MSU.MSUModName, true);

//need to set this first to print the others
this.MSU.Systems.Debug.setFlags(this.MSU.MSUModName, this.MSU.Systems.Debug.MSUMainDebugFlag);

this.MSU.Systems.Debug.setFlags(this.MSU.MSUModName, this.MSU.Systems.Debug.MSUDebugFlags);

this.MSU.Systems.Debug.registerMod(this.MSU.Systems.Debug.VanillaLogName, true);