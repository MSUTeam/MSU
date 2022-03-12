::MSU.Class.KeybindJS <- class extends ::MSU.Class.Keybind
{
	function getForJS()
	{
		return {
			key = this.getKey(),
			name = this.getName()
		}
	}
}
