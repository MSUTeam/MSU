::mods_hookChildren("states/state", function(o) {
	local stateMap = { // TODO
		world_state = ::MSU.Key.State.World,
		tactical_state = ::MSU.Key.State.Tactical,
		main_menu_state = ::MSU.Key.State.MainMenu
	}

	local onInit = o.onInit;
	o.onInit = function()
	{
		::MSU.Utils.States[this.ClassName] <- ::WeakTableRef(this);
		return onInit();
	}

	if ("onKeyInput" in o && "onMouseInput" in o)
	{
		local onKeyInput = o.onKeyInput;
		o.onKeyInput = function( _key )
		{
			if (!::MSU.Key.isKnownKey(_key))
			{
				return onKeyInput(_key);
			}
			if (::MSU.System.Keybinds.onKeyInput(_key, this, stateMap[this.ClassName]))
			{
				return false;
			}
			return onKeyInput(_key);
		}

		local onMouseInput = o.onMouseInput;
		o.onMouseInput = function( _mouse )
		{
			if (!::MSU.Key.isKnownMouse(_mouse))
			{
				return onMouseInput(_mouse);
			}
			if (::MSU.System.Keybinds.onMouseInput(_mouse, this, stateMap[this.ClassName]))
			{
				return false;
			}
			return onMouseInput(_mouse);
		}
	}
});
