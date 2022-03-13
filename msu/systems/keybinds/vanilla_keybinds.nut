::MSU.System.Keybinds.registerMod(::MSU.VanillaID);
function addKeybind( _id, _keyCombinations, _state, _function, _name,  _keyState = null )
{
	::MSU.System.Keybinds.add(::MSU.Class.KeybindSQ(::MSU.VanillaID, _id, _keyCombinations, _state, _function, _name, _keyState));
}

addKeybind("character_closeCharacterScreen", "c/i/escape", ::MSU.Key.State.World, function()
{
	if (!this.isInCharacterScreen()) return;
	this.toggleCharacterScreen();
	return false;
}, "Close Character Screen");

addKeybind("character_openCharacterScreen", "c/i", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps() || this.m.CharacterScreen.isVisible() || this.m.WorldTownScreen.isVisible() && !this.m.EventScreen.isVisible())
	{
		if (!this.m.EventScreen.isVisible() && !this.m.EventScreen.isAnimating())
		{
			this.toggleCharacterScreen();
			return false;
		}
	}
}, "Open Character Screen");

addKeybind("character_switchToPreviousBrother", "left/a", ::MSU.Key.State.World, function()
{
	if (!this.isInCharacterScreen()) return;
	this.m.CharacterScreen.switchToPreviousBrother();
	return false;
}, "Switch to Previous Brother");

addKeybind("character_switchToNextBrother", "right/d", ::MSU.Key.State.World, function()
{
	if (!this.isInCharacterScreen()) return;
	this.m.CharacterScreen.switchToNextBrother();
	return false;
}, "Switch to Next Brother");


