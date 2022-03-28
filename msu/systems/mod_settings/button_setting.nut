::MSU.Class.ButtonSetting <- class extends ::MSU.Class.AbstractSetting
{
	static Type = "Button";

	function onPressedCallback()
	{
		foreach (callback in this.Callbacks)
		{
			callback.call(this);
		}
	}
}
