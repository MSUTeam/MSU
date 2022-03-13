::MSU.Class.KeybindJS <- class extends ::MSU.Class.Keybind
{
	function getUIData()
	{
		return {
			modID = this.getModID(),
			id = this.getID(),
			keyCombinations = this.getKeyCombinations(),
			keyState = this.KeyState
		}
	}
}
