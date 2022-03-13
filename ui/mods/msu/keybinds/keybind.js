MSUKeybind = function( _modID, _id, _function )
{
	this.ModID = _modID;
	this.ID = _id;
	this.Function = _function;
	this.KeyCombinations = "";
	this.KeyState = 0;
}

MSUKeybind.prototype.initFromSQ = function( _keyCombinations, _keyState )
{
	this.KeyCombinations = _keyCombinations;
	this.KeyState = _keyState;
}

MSUKeybind.prototype.getRawKeyCombinations = function()
{
	return this.KeyCombinations.split('/');
}

MSUKeybind.prototype.callFunction = function( _event )
{
	return this.Function(_event);
}

MSUKeybind.prototype.callOnKeyState = function( _keyState )
{
	return (this.KeyState & _keyState) != 0;
}
