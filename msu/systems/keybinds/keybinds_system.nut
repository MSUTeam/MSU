::MSU.Class.KeybindsSystem <- class extends ::MSU.Class.System
{
	KeybindsByKey = null;
	KeybindsByMod = null;
	KeybindsForJS = null;
	PressedKeys = null;
	KeysChanged = false;

	constructor()
	{
		base.constructor(::MSU.SystemID.Keybinds);
		this.KeybindsByKey = {};
		this.KeybindsByMod = {};
		this.KeybindsForJS = {};
		this.PressedKeys = {};
	}

	function registerMod( _mod )
	{
		base.registerMod(_mod);
		if (!::MSU.System.ModSettings.hasPanel(_mod.getID()))
		{
			::MSU.System.ModSettings.registerMod(_mod);
		}

		_mod.Keybinds = ::MSU.Class.KeybindsModAddon(_mod);

		::MSU.System.ModSettings.getPanel(_mod.getID()).addPage(::MSU.Class.SettingsPage("Keybinds"));

		this.KeybindsByMod[_mod.getID()] <- {};
		this.KeybindsForJS[_mod.getID()] <- {};
	}

	function add( _keybind, _makeSetting = true )
	{
		if (!(_keybind instanceof ::MSU.Class.AbstractKeybind))
		{
			throw ::MSU.Exception.InvalidType(_keybind);
		}
		if (_keybind instanceof ::MSU.Class.KeybindJS)
		{
			if (::MSU.UI.JSConnection.isConnected())
			{
				::MSU.UI.JSConnection.addKeybind(_keybind);
			}
			this.KeybindsForJS[_keybind.getModID()][_keybind.getID()] <- _keybind;
		}
		else
		{
			foreach (key in _keybind.getRawKeyCombinations())
			{
				::MSU.Mod.Debug.printWarning(format("Adding keyCombination %s for keybind %s", key, _keybind.getID()), "keybinds")
				if (!(key in this.KeybindsByKey))
				{
					this.KeybindsByKey[key] <- [];
					::MSU.Mod.Debug.printWarning("Creating Keybind array for key: " + key, "keybinds")
				}
				this.KeybindsByKey[key].push(_keybind);
			}
		}

		this.KeybindsByMod[_keybind.getModID()][_keybind.getID()] <- _keybind;
		if (_makeSetting)
		{
			this.addKeybindSetting(_keybind);
		}
	}

	// Private
	function remove( _modID, _id )
	{
		::MSU.Mod.Debug.printWarning("Removing Keybind" + this.KeybindsByMod[_modID][_id], "keybinds");
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

	function update( _modID, _id, _keyCombinations, _updateJS = true, _updatePersistence = true, _updateCallback = true )
	{
		local keybind = this.remove(_modID, _id);
		keybind.KeyCombinations = split(::MSU.Key.sortKeyCombinationsString(_keyCombinations),"/");
		::getModSetting(_modID, _id).set(keybind.getKeyCombinations(), _updateJS, _updatePersistence, _updateCallback);
		this.add(keybind, false);
	}

	function updateBaseValue( _modID, _id, _keyCombinations, _updateJS = true, _updatePersistence = true, _updateCallback = true )
	{
		local keybind = this.remove(_modID, _id);
		keybind.KeyCombinations = split(::MSU.Key.sortKeyCombinationsString(_keyCombinations),"/");
		::getModSetting(_modID, _id).setBaseValue(keybind.getKeyCombinations(), _updateJS, _updatePersistence, _updateCallback, true);
		this.add(keybind, false);
	}

	function updateFromPersistence( _modID, _id, _keyCombinations )
	{
		if(!(_modID in this.KeybindsByMod))
		{
			::logError(format("Trying to update keybind %s for mod %s but mod does not exist!"), _id, _modID);
			return;
		}
		this.update(_modID, _id, _keyCombinations, true, false, false);
	}

	function call( _key, _environment, _state, _keyState )
	{
		if (!(_key in this.KeybindsByKey))
		{
			return;
		}

		foreach (keybind in this.KeybindsByKey[_key])
		{
			::MSU.Mod.Debug.printWarning("Checking keybind: " + keybind.tostring(), "keybinds");
			if (!keybind.hasState(_state))
			{
				continue;
			}

			if (!keybind.callOnKeyState(_keyState))
			{
				continue;
			}

			::MSU.Mod.Debug.printWarning("Calling keybind", "keybinds");
			if (keybind.call(_environment) == true)
			{
				::MSU.Mod.Debug.printWarning("Returning after keybind call returned true.", "keybinds");
				return true;
			}
		}
	}

	function addKeybindSetting( _keybind )
	{
		::MSU.System.ModSettings.getPanel(_keybind.getModID()).getPage("Keybinds").addElement(_keybind.makeSetting());
	}

	function getJSKeybinds()
	{
		// ret = [
		// 	{
		// 		id = "modID",
		// 		keybinds = [
		// 			{
		// 				id = "keybindID",
		// 				keyCombinations = "x/y+z",
		// 				keyState = ::MSU.Key.Keystate.Release
		// 			}
		// 		]
		// 	}
		// ]
		local ret = []
		foreach (mod in this.KeybindsForJS)
		{
			foreach (keybind in mod)
			{
				ret.push(keybind.getUIData());
			}
		}
		return ret;
	}

	function onKeyInput( _key, _environment, _state )
	{
		this.KeysChanged = true;
		local keyAsString = ::MSU.Key.KeyMapSQ[_key.getKey().tostring()];
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

	function frameUpdate( _ = null) # needs an empty default parameter since scheduleEvent uses .call(_env)
	{
		if (!this.KeysChanged && this.PressedKeys.len() != 0)
		{
			::MSU.UI.JSConnection.clearKeys();
			this.PressedKeys = {};
		}
		this.KeysChanged = false;
		::Time.scheduleEvent(::TimeUnit.Real, 1, this.frameUpdate.bindenv(this), null);
	}

	function onMouseInput( _mouse, _environment, _state )
	{
		local keyAsString = ::MSU.Key.MouseMapSQ[_mouse.getID().tostring()];
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

		if (_key.getState() == 1)
		{
			if (key in this.PressedKeys)
			{
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

	function importPersistentSettings()
	{
		::MSU.System.PersistentData.loadFileForEveryMod("Keybind");
	}
}
