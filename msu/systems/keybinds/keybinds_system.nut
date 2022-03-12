this.MSU.Class.KeybindsSystem <- class extends this.MSU.Class.System
{
	KeybindsByKey = null;
	KeybindsByMod = null;
	KeybindsForJS = null;
	IsConnected = null;
	PressedKeys = null;

	constructor()
	{
		base.constructor(this.MSU.SystemID.Keybinds);
		this.KeybindsByKey = {};
		this.KeybindsByMod = {};
		this.KeybindsForJS = {};
		this.IsConnected = false;
		this.PressedKeys = {};
	}

	function registerMod( _modID )
	{
		base.registerMod(_modID);
		if (!::MSU.System.ModSettings.has(_modID))
		{
			::MSU.System.ModSettings.registerMod(_modID);
		}
		::MSU.System.ModSettings.get(_modID).addPage("Keybinds");

		this.KeybindsByMod[_modID] <- [];
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
			if (!(_keybind.getKey() in this.KeybindsByKey))
			{
				this.KeybindsByKey[_keybind.getKey()] <- [];
			}
			this.KeybindsByKey[_keybind.getKey()].push(_keybind);
		}

		this.KeybindsByMod[_keybind.getModID()][_keybind.getID()] <- _keybind;
		if (this.IsConnected && _makeSetting)
		{
			this.addKeybindSetting(_keybind)
		}
	}

	function update( _modID, _id, _key )
	{
		//remove start
		local keybind = this.KeybindsByMod[_modID].rawdelete(_id);
		if (_keybind instanceof ::MSU.Class.KeybindJS)
		{
			this.KeybindsForJS[_modID].rawdelete(_id);
			::MSU.UI.JSConnection.removeKeybind(keybind);
		}
		else
		{
			this.KeybindsByKey[keybind.getKey()].remove(this.KeybindsByKey[keybind.getKey()].find(keybind));
		}
		//remove end

		keybind.Key = _key;
		::getModSetting(_modID, _id).set(_key);

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
			::printWarning(format("Checking handler function: key %s | ID %s | State %s", keybind.getKey(), keybind.getID(), keybind.getState().tostring()), this.MSU.ID, "keybinds");
			if (keybind.getState() != _state && keybind.getState != ::MSU.Key.State.All)
			{
				continue;
			}

			if (!keybind.callOnKeyState(_keyState))
			{
				continue;
			}

			::printWarning(format("Calling handler function: key %s | ID %s | State %s", keybind.getKey(), keybind.getID(), keybind.getState().tostring()), this.MSU.ID, "keybinds");
			if (!keybind.call(_environment))
			{
            	::printWarning("Returning after keybind call returned false.", ::MSU.ID, "keybinds");
				return false;
			}
		}
	}

	function addKeybindSetting( _keybind )
	{
		::MSU.System.ModSettings.get(modID).getPage("Keybinds").add(keybind.makeSetting());
	}

	function makeSettings()
	{
		foreach (modID, mod in this.KeybindsByMod)
		{
			foreach (keybind in mod)
			{
				this.addKeybindSetting(keybind);
			}
		}
		this.IsConnected = true;
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
		return this.onInput(_key, _environment, _state, keyAsString);
	}

	function onMouseInput( _key, _environment, _state )
	{
		local keyAsString = _key.getID().tostring();
		if (!(keyAsString in ::MSU.Key.KeyMapSQMouse))
		{
			::printWarning("Unknown key pressed: %s" + _key.getID(), ::MSU.ID, "keybinds");
			return;
		}
		keyAsString = ::MSU.Key.KeyMapSQMouse[keyAsString];
		return this.onInput(_key, _environment, _state, keyAsString);
	}

	// Private
	function onInput( _key, _environment, _state, _keyAsString )
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
		return this.call(key, _environment, _state, _key.getState());
	}

	function updatePressedKey( _key )
	{
		local key = _key.getKey().tostring();
		if (!(key in ::MSU.Key.KeyMapSQ))
		{
			return false;
		}

		key = ::MSU.Key.KeyMapSQ[key];
		local wasPressed = key in this.PressedKeys;
		if (_key.getState() == 1)
		{
			if (wasPressed)
			{
				return false;
			}
			this.PressedKeys[key] <- 1;
		}
		else
		{
			delete this.PressedKeys[key];
		}
		return true;
	}
}
