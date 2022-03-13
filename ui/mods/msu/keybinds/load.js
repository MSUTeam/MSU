document.addEventListener('keydown', function( _event )
{
	var key = MSU.Key.KeyMapJS[_event.keyCode];
	if (key === undefined || key === null)
	{
		return;
	}
	var keyState = MSU.Keybinds.isKeyStateContinuous(key, false) ? MSU.Key.KeyState.Continuous : MSU.Key.KeyState.Press;
	if (MSU.Keybinds.onInput(key, _event, keyState) === false)
	{
		event.stopPropagation();
	}
});

document.addEventListener('keyup', function( _event )
{
	var key = MSU.Key.KeyMapJS[_event.keyCode];
	if (key === undefined || key === null)
	{
		return;
	}
	MSU.Keybinds.isKeyStateContinuous(key, true);
	if (MSU.Keybinds.onInput(key, _event, MSU.Key.KeyState.Release) === false)
	{
		event.stopPropagation();
	}
});

document.addEventListener('mouseup', function( _event ){
	var key = MSU.Key.MouseMapJS[_event.button]
	if (key === undefined || key === null)
	{
		return;
	}
	if (MSU.Keybinds.onInput(key, _event, MSU.Key.KeyState.Release) === false)
	{
		event.stopPropagation();
	}
});

document.addEventListener('mousedown', function( _event ){
	var key = MSU.Key.MouseMapJS[_event.button]
	if (key === undefined || key === null)
	{
		return;
	}
	if (MSU.Keybinds.onInput(key, _event, MSU.Key.KeyState.Press) === false)
	{
		event.stopPropagation();
	}
});


// MSU.Keybinds.addKeybindFunction('mod_MSU', 'testkb', function()
// {
// 	console.error("testkb")
// })
