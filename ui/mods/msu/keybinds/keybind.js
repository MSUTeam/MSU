MSUKeybind = function( _modID, _id, _keyCombinations, _keyState, _function = null )
{
	this.ModID = _modID;
	this.ID = _id;
	this.KeyCombinations = _keyCombinations;
	this.KeyState = _keyState;
	this.Function = _function;
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
	return (this.Keystate & _keyState) != 0;
}
