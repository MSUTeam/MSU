::MSU.Class.KeybindJS <- class extends ::MSU.Class.Keybind
{
	function getForJS()
	{
		return {
			Key = this.getKey(),
			Name = this.getName()
		}
	}
}
