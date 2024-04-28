::MSU.Class.KeybindSQ <- class extends ::MSU.Class.AbstractKeybind
{
	Function = null;
	State = null;
	KeyState = null;
	CallContinuously = false;
	TriggerDelay = null;
	NextCallTime = null;
	BypassInputDenied = false;

	constructor( _modID, _id, _keyCombinations, _state, _function, _name = null, _keyState = null)
	{
		if (_keyState == null) _keyState = ::MSU.Key.KeyState.Release;
		::MSU.requireFunction(_function);
		base.constructor(_modID, _id, _keyCombinations, _name);
		::MSU.Key.isValidCombination(this.KeyCombinations);

		this.Function = _function;
		this.State = _state;
		this.KeyState = _keyState;
	}

	function setBypassInputDenied(_bool)
	{
		this.BypassInputDenied = _bool;
	}

	function setCallContinuously(_bool, _triggerDelay = null)
	{
		this.CallContinuously = _bool;
		this.TriggerDelay = _triggerDelay;
		return this;
	}

	function getState()
	{
		return this.State;
	}

	function hasState( _state )
	{
		return (this.State & _state) != 0;
	}

	function checkContinuousCall(_keyState)
	{
		return ((this.KeyState & ::MSU.Key.KeyState.Continuous) != 0) && ((this.NextCallTime == null) || (::Time.getRealTimeF() > this.NextCallTime));
	}

	function callOnKeyState( _keyState )
	{
		if (this.CallContinuously && _keyState == ::MSU.Key.KeyState.Continuous)
			return this.checkContinuousCall(_keyState)
		return (_keyState & this.KeyState) != 0;
	}

	function getKeyState()
	{
		return this.KeyState;
	}

	function setFunction( _function )
	{
		this.Function = _function;
	}

	function call( _environment )
	{
		local ret = this.Function.call(_environment);
		if (ret && this.CallContinuously && this.TriggerDelay != null)
			this.NextCallTime = ::Time.getRealTimeF() + this.TriggerDelay;
		return ret;
	}

	function tostring()
	{
		return base.tostring() + ", Keystate: " + this.getKeyState() + ", State: " + this.getState();
	}
}
