document.addEventListener('keydown', function( _event )
{
	var key = MSU.Key.KeyMapJS[_event.keyCode];
	if (key === undefined || key === null)
	{
		return;
	}
	var keyState = MSU.Keybinds.isKeyStateContinuous(key, true) ? MSU.Key.State.Continuous : MSU.Key.State.Release;
	if (MSU.Keybinds.onInput(key, _event, _keyState) === false)
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
	MSU.Keybinds.isKeyStateContinuous(key, false);
	if (MSU.Keybinds.onInput(key, _event, MSU.Key.State.Release) === false)
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
	if (MSU.Keybinds.onInput(key, _event, MSU.Key.State.Release) === false)
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
	if (MSU.Keybinds.onInput(key, _event, MSU.Key.State.Press) === false)
	{
		event.stopPropagation();
	}
});
