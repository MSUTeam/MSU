::MSU.Class.KeybindsSystem <- class extends ::MSU.Class.System
{
	KeybindsByKey = null;
	KeybindsByMod = null;
	KeybindsForJS = null;
	PressedKeys = null;
	KeysChanged = false;
	__BlockUserInputs = false;

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
		else if (_keybind instanceof ::MSU.Class.KeybindSQ)
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
		else if (keybind instanceof ::MSU.Class.KeybindSQ)
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
		local isKeyNewlyPressed = this.__updatePressedKeysAndReturnIfNew(_key);
		local keyState;
		if (isKeyNewlyPressed) keyState = ::MSU.Key.KeyState.Press;
		else
		{
			keyState = ::MSU.Key.getKeyState(_key.getState());
			if (keyState == ::MSU.Key.KeyState.Press) keyState = ::MSU.Key.KeyState.Continuous;
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
		return this.call(this.__getPressedKeysString(_keyAsString), _environment, _state, _keyState);
	}

	function isKeybindPressed( _modID, _id )
	{
		local keybind = this.KeybindsByMod[_modID][_id];
		foreach (rawKeyCombination in keybind.getRawKeyCombinations())
		{
			local keyCombination = split(rawKeyCombination, "+");
			if (keyCombination.len() != this.PressedKeys.len()) continue;
			local failedKeyCombination = false;
			foreach (key in keyCombination)
			{
				if (!(key in this.PressedKeys))
				{
					failedKeyCombination = true;
					break;
				}
			}
			if (failedKeyCombination) continue;
			return true;
		}
		return false;
	}

	function __updatePressedKeysAndReturnIfNew( _key )
	{
		// Assumes _key is in KeyMapSQ
		local keyAsString = ::MSU.Key.KeyMapSQ[_key.getKey().tostring()];
		if (::MSU.Key.getKeyState(_key.getState()) == ::MSU.Key.KeyState.Press)
		{
			if(!(keyAsString in this.PressedKeys))
			{
				this.PressedKeys[keyAsString] <- 1;
				return true;
			}
		}
		else if (keyAsString in this.PressedKeys) // in case the keypress started while tabbed out
		{
			delete this.PressedKeys[keyAsString];
		}
		return false;
	}

	function __getPressedKeysString( _lastKeyAsString )
	{
		local pressedKeysString = "";
		foreach (pressedKeyID, value in this.PressedKeys)
		{
			if (_lastKeyAsString != pressedKeyID)
			{
				pressedKeysString += pressedKeyID + "+";
			}
		}
		return ::MSU.Key.sortKeyString(pressedKeysString + _lastKeyAsString);
	}

	function isBlockingUserInputs()
	{
		return this.__BlockUserInputs;
	}

	function __listenForAndBlockUserInputs()
	{
		this.PressedKeys.clear();
		this.__BlockUserInputs = true;
	}

	function __handleBlockedUserKeyInput( _key )
	{
		this.__updatePressedKeysAndReturnIfNew(_key);
		if (::MSU.Key.getKeyState(_key.getState()) == ::MSU.Key.KeyState.Release)
			this.__notifyUIBlockedInputKeyReleased(::MSU.Key.KeyMapSQ[_key.getKey().tostring()]);
	}

	function __handleBlockedUserMouseInput( _mouse )
	{
		if (::MSU.Key.MouseMapSQ(_key.getID()) == ::MSU.Key.KeyState.Release)
			this.__notifyUIBlockedInputKeyReleased(::MSU.Key.MouseMapSQ[_mouse.getID().tostring()]);
	}

	function __notifyUIBlockedInputKeyReleased( _keyAsString )
	{
		this.__BlockUserInputs = false;
		local pressedKeysString = this.__getPressedKeysString(_keyAsString);
		::MSU.SettingsScreen.releaseUserInputWithKeyCombination(pressedKeysString);
	}

	function importPersistentSettings()
	{
		::MSU.System.PersistentData.loadFileForEveryMod("Keybind");
	}
}
