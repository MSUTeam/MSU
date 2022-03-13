::MSU.Class.KeybindJS <- class extends ::MSU.Class.Keybind
{
	function getForJS()
	{
		return {
			id = this.getID(),
			KeyCombinations = this.getKeyCombinations(),
			keyState = this.KeyState
		}
	}
}
