::MSU.Class.KeybindSQ <- class extends ::MSU.Class.Keybind
{
	Function = null;
	State = null;

	constructor( _modID, _id, _keyCombinations, _state, _function, _name = null, _keyState = null)
	{
		::MSU.requireFunction(_function);
		base.constructor(_modID, _id, _keyCombinations, _name);

		this.Function = _function;
		this.State = _state;
	}

	function hasState( _state )
	{
		return (this.State & _state) != 0;
	}

	function setFunction( _function )
	{
		this.Function = _function;
	}

	function call( _environment )
	{
		return this.Function.call(_environment);
	}
}
