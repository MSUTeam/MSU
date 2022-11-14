::MSU.Class.KeybindJS <- class extends ::MSU.Class.AbstractKeybind
{
	constructor( _modID, _id, _keyCombinations, _name = null)
	{
		base.constructor(_modID, _id, _keyCombinations, _name);
		::MSU.Key.isValidCombination(this.KeyCombinations, false);
	}

	function getUIData( _flags = [] )
	{
		return {
			modID = this.getMod().getID(),
			id = this.getID(),
			keyCombinations = this.getKeyCombinations()
		};
	}
}
