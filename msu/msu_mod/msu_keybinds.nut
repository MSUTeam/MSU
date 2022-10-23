::MSU.Mod.Keybinds.addSQKeybind("ClosePopup", "escape", ::MSU.Key.State.All, function()
{
	if (::MSU.Popup.isVisible() && !::MSU.Popup.isAnimating())
	{
		if (::MSU.Popup.isForceQuitting())
		{
			::MSU.Popup.quitGame();
		}
		else
		{
			::MSU.Popup.hide();
		}
		return true;
	}
	return false;
}, "Close MSU Popup");
