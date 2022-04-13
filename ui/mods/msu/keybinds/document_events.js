document.addEventListener('keydown', function( _event )
{
	var key = MSU.Key.KeyMapJS[_event.keyCode];
	if (key === undefined || key === null)
	{
		return;
	}
	MSU.Keybinds.updatePressedKeys(key, false);
});

document.addEventListener('keyup', function( _event )
{
	var key = MSU.Key.KeyMapJS[_event.keyCode];
	if (key === undefined || key === null)
	{
		return;
	}
	MSU.Keybinds.updatePressedKeys(key, true);
});
