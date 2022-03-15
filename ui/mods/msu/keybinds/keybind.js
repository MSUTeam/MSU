MSUKeybind = function( _modID, _id, _function, _keyCombinations, _keyState )
{
	if (_keyCombinations === undefined) _keyCombinations = null;
	if (_keyCombinations === undefined) _keyState = null;
	if (_function === undefined) _function = null;

	this.ModID = _modID;
	this.ID = _id;
	this.Function = _function;
	this.KeyCombinations = _keyCombinations;
	this.KeyState = _keyState;
}

MSUKeybind.prototype.initFromSQ = function( _keyCombinations, _keyState )
{
	this.KeyCombinations = _keyCombinations;
	this.KeyState = _keyState;
}

MSUKeybind.prototype.initFromJS = function( _function )
{
	this.Function = _function;
}

MSUKeybind.prototype.isFullyInit = function()
{
	return this.Function != null && this.KeyCombinations != null && this.KeyState != null;
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
