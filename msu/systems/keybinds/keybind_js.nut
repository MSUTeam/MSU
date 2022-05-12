::MSU.Class.KeybindJS <- class extends ::MSU.Class.AbstractKeybind
{
	function getUIData( _flags = [] )
	{
		return {
			modID = this.getModID(),
			id = this.getID(),
			keyCombinations = this.getKeyCombinations()
		};
	}
}
