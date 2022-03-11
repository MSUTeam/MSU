::MSU.Class.KeybindSQ <- class extends ::MSU.Class.Keybind
{
	Function = null;
	State = null;

	constructor( _modID, _id, _key, _state, _function, _name = null)
	{
		::MSU.requireFunction(_function);
		if (!(_state in ::MSU.Key.State))
		{
			this.logError("_state must be one of the keys in ::MSU.Key.State");
			throw ::Exception.KeyNotFound;
		}

		base.constructor(_modID, _id, _key, _name);

		this.Function = _function;
		this.State = _state;
	}

	function getState()
	{
		return this.State;
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
