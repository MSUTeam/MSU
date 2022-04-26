::MSU.Class.KeybindSetting <- class extends ::MSU.Class.StringSetting
{
	static Type = "Keybind";
	// Maybe add a keybind combination validator at some point

	function printForParser()
	{
		base.printForParser(this.Type);
	}
}
