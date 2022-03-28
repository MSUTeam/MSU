::MSU.Class.KeybindSetting <- class extends ::MSU.Class.StringSetting
{
	static Type = "Keybind";
	// Maybe add a keybind combination validator at some point

	function printForParser()
	{
		::MSU.PersistentDataManager.writeToLog("Keybind", this.getPanelID(), format("%s;%s", this.getID(), this.getValue().tostring()));
	}
}
