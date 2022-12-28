::MSU.Class.ButtonSetting <- class extends ::MSU.Class.AbstractSetting
{
	static Type = "Button";

	function onPressedCallback()
	{
		foreach (callback in this.BeforeChangeCallbacks)
		{
			callback.call(this);
		}
	}

	// dummy overwrites as buttons don't implement serialization, might want to improve at a later date
	function flagSerialize( _out ) {}

	function flagDeserialize( _in ) {}

	function reset() {}
}
