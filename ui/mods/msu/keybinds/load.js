document.addEventListener('keydown', function( _event )
{
	var key = MSU.Key.KeyMapJS[_event.keyCode];
	if (key === undefined || key === null)
	{
		console.error("Unknown key: " + key)
		return;
	}
	MSU.Keybinds.updatePressedKeys(key, false);
});

document.addEventListener('keyup', function( _event )
{
	var key = MSU.Key.KeyMapJS[_event.keyCode];
	if (key === undefined || key === null)
	{
		console.error("Unknown key: " + key);
		return;
	}
	MSU.Keybinds.updatePressedKeys(key, true);
});


// MSU.Keybinds.addKeybindFunction('mod_MSU', 'testkb', function()
// {
// 	console.error("testkb")
// })
