this.MSU.Class.KeybindsSystem <- class extends this.MSU.Class.System
{
	KeybindsByKey = null;
	KeybindsByMod = null;
	KeybindsForJS = null;
	PressedKeys = null;

	constructor()
	{
		base.constructor(this.MSU.SystemID.Keybinds);
		this.KeybindsByKey = {};
		this.KeybindsByMod = {};
		this.KeybindsForJS = {};
		this.PressedKeys = {};
	}

	function registerMod( _modID )
	{
		base.registerMod(_modID);
		if (!::MSU.System.ModSettings.has(_modID))
		{
			::MSU.System.ModSettings.registerMod(_modID);
		}

		::MSU.System.ModSettings.get(_modID).addPage(::MSU.Class.SettingsPage("Keybinds"));

		this.KeybindsByMod[_modID] <- {};
		this.KeybindsForJS[_modID] <- {};
	}

	// maybe add a Bind suffix to all these functions: eg addBind, updateBind etc
	function add( _keybind, _makeSetting = true )
	{
		if (!(_keybind instanceof ::MSU.Class.Keybind))
		{
			throw this.Exception.InvalidType;
		}
		if (_keybind instanceof ::MSU.Class.KeybindJS)
		{
			this.KeybindsForJS[_keybind.getModID()][_keybind.getID()] <- _keybind;
		}
		else
		{
			foreach (key in _keybind.getRawKeyCombinations())
			{
				::printWarning(format("Adding keyCombination %s for keybind %s", key, _keybind.getID()), ::MSU.ID, "keybinds")
				if (!(key in this.KeybindsByKey))
				{
					this.KeybindsByKey[key] <- [];
					::printWarning("Creating Keybind array for key: " + key, ::MSU.ID, "keybinds")
				}
				this.KeybindsByKey[key].push(_keybind);
			}
		}

		this.KeybindsByMod[_keybind.getModID()][_keybind.getID()] <- _keybind;
		if (_makeSetting)
		{
			this.addKeybindSetting(_keybind)
		}
	}

	// Private
	function remove( _modID, _id )
	{
		this.logInfo(this.KeybindsByMod[_modID][_id]);
		local keybind = this.KeybindsByMod[_modID].rawdelete(_id);
		if (keybind instanceof ::MSU.Class.KeybindJS)
		{
			this.KeybindsForJS[_modID].rawdelete(_id);
			::MSU.UI.JSConnection.removeKeybind(keybind);
		}
		else
		{
			foreach (key in keybind.getRawKeyCombinations())
			{
				this.KeybindsByKey[key].remove(this.KeybindsByKey[key].find(keybind));
				if (this.KeybindsByKey[key].len() == 0)
				{
					this.KeybindsByKey.rawdelete(key);
				}
			}
		}
		return keybind;
	}

	function update( _modID, _id, _keyCombinations )
	{
		local keybind = this.remove(_modID, _id);
		keybind.KeyCombinations = split(::MSU.Key.sortKeyCombinationsString(_keyCombinations),"/");
		::getModSetting(_modID, _id).set(keybind.getKeyCombinations(), true, true, false);
		this.add(keybind, false);
	}

	function call( _key, _environment, _state, _keyState )
	{
		if (!(_key in this.KeybindsByKey))
		{
			return;
		}

		foreach (keybind in this.KeybindsByKey[_key])
		{
			::printWarning("Checking keybind: " + keybind.tostring(), ::MSU.ID, "keybinds");
			if (!keybind.hasState(_state))
			{
				continue;
			}

			if (!keybind.callOnKeyState(_keyState))
			{
				continue;
			}

			::printWarning("Calling keybind", this.MSU.ID, "keybinds");
			if (keybind.call(_environment) == false)
			{
            	::printWarning("Returning after keybind call returned false.", ::MSU.ID, "keybinds");
				return false;
			}
		}
	}

	function addKeybindDivider( _modID, _id, _name )
	{
		::MSU.System.ModSettings.get(_modID).getPage("Keybinds").add(::MSU.Class.SettingsDivider(_id, _name));
	}

	function addKeybindSetting( _keybind )
	{
		::MSU.System.ModSettings.get(_keybind.getModID()).getPage("Keybinds").add(_keybind.makeSetting());
	}

	function getJSKeybinds()
	{
		// ret = {
		// 	modID = {
		// 		keybindID = {
		// 			name = "",
		// 			key = ""
		// 		}
		// 	}
		// }
		local ret = {}
		foreach (modID, mod in this.KeybindsForJS)
		{
			ret[modID] <- {};
			foreach (keybindID, keybind in mod)
			{
				ret[modID][keybindID] <- keybind.getForJS();
			}
		}
		return ret;
	}

	function onKeyInput( _key, _environment, _state )
	{
		local keyAsString = _key.getKey().tostring();
		if (!(keyAsString in ::MSU.Key.KeyMapSQ))
		{
			::printWarning("Unknown key pressed: %s" + _key.getKey(), ::MSU.ID, "keybinds");
			return;
		}
		keyAsString = ::MSU.Key.KeyMapSQ[keyAsString];
		local keyState;
		if (this.isKeyStateContinuous(_key))
		{
			keyState = ::MSU.Key.KeyState.Continuous;
		}
		else
		{
			keyState = ::MSU.Key.getKeyState(_key.getState())
		}
		return this.onInput(_key, _environment, _state, keyAsString, keyState);
	}

	function onMouseInput( _mouse, _environment, _state )
	{
		local keyAsString = _mouse.getID().tostring();
		if (!(keyAsString in ::MSU.Key.MouseMapSQ))
		{
			::printWarning("Unknown key pressed: %s" + _mouse.getID(), ::MSU.ID, "keybinds");
			return;
		}
		keyAsString = ::MSU.Key.MouseMapSQ[keyAsString];
		return this.onInput(_mouse, _environment, _state, keyAsString, _mouse.getState());
	}

	// Private
	function onInput( _key, _environment, _state, _keyAsString, _keyState )
	{
		local key = "";
		foreach (pressedKeyID, value in this.PressedKeys)
		{
			if (_keyAsString != pressedKeyID)
			{
				key += pressedKeyID + "+";
			}
		}
		key += _keyAsString;
		return this.call(key, _environment, _state, _keyState);
	}

	function isKeyStateContinuous( _key )
	{
		// Assumes key is in KeyMapSQ
		local key = ::MSU.Key.KeyMapSQ[_key.getKey().tostring()];
		::MSU.Log.printData(this.PressedKeys)

		if (_key.getState() == 1)
		{
			this.logInfo("keystate 1" + _key.getKey());
			if (key in this.PressedKeys)
			{
				this.logInfo("should be continuous");
				return true;
			}
			this.PressedKeys[key] <- 1;
		}
		else
		{
			if (key in this.PressedKeys) // in case the keypress started while tabbed out for example
			{
				delete this.PressedKeys[key];
			}
		}
		return false;
	}
}
