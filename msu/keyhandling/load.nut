local function includeFile(_file)
{
	::includeFile("msu/keyhandling/", _file);
}
includeFile("custom_keybinds.nut");
includeFile("global_keyhandler.nut");


if (this.MSU.System.Debug.isEnabledForMod(this.MSU.ID,"keybinds"))
{
	includeFile("key_testing.nut");
}

#includeFile("vanilla_keybinds.nut");
