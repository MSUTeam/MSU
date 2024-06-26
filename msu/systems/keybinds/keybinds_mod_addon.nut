::MSU.Class.KeybindsModAddon <- class extends ::MSU.Class.SystemModAddon
{
	function addSQKeybind( _id, _keyCombinations, _state, _function, _name = null, _keyState = null, _description = "" )
	{
		local keybind = ::MSU.Class.KeybindSQ(this.Mod.getID(), _id, _keyCombinations, _state, _function, _name, _keyState);
		keybind.setDescription(_description);
		return ::MSU.System.Keybinds.add(keybind);
	}

	function addJSKeybind( _id, _keyCombinations, _name = null, _description = "" )
	{
		local keybind = ::MSU.Class.KeybindJS(this.Mod.getID(), _id, _keyCombinations, _name);
		keybind.setDescription(_description);
		return ::MSU.System.Keybinds.add(keybind);
	}

	function addPassiveKeybind( _id, _keyCombinations, _name = null, _description = "" )
	{
		local keybind = ::MSU.Class.KeybindSQPassive(this.Mod.getID(), _id, _keyCombinations, _name);
		keybind.setDescription(_description);
		return ::MSU.System.Keybinds.add(keybind);
	}

	function isKeybindPressed( _id )
	{
		return ::MSU.System.Keybinds.isKeybindPressed(this.Mod.getID(), _id);
	}

	function addDivider( _id )
	{
		::MSU.System.ModSettings.getPanel(this.Mod.getID()).getPage("Keybinds").addDivider(_id);
	}

	function addTitle( _id, _name )
	{
		::MSU.System.ModSettings.getPanel(this.Mod.getID()).getPage("Keybinds").addTitle(_id, _name);
	}

	// Deprecated, use ModSettings set() instead
	function update( _id, _keyCombinations )
	{
		::MSU.System.ModSettings.getPanel(this.Mod.getID()).getSetting(_id).set(_keyCombinations);
	}
}
