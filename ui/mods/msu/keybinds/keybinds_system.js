MSU.Keybinds = {
	KeybindsByKey = {},
	KeybindsByMod = {},
	PressedKeys = {},
	KeybindsToParse = [],
	addKeybindFromSQ( _keybind )
	{
		if (!(_keybind.ModID in this.KeybindsByMod))
		{
			this.KeybindsByMod = {};
		}
		this.KeybindsByMod[_keybind.ModID][_keybind.ID] = keybind;
	},

	addKeybindFunction( _modID, _id, _function )
	{
		var keybind = this.KeybindsByMod[_modID][_id];
		keybind.Function = _function;
		this.addKeybindToKeybindsByKey(keybind);
	},

	addKeybindToKeybindsByKey(_keybind)
	{
		var rawKeyCombinations = keybind.getRawKeyCombinations();
		for (var i = 0; i < rawKeyCombinations.length; i++)
		{
			if (!(rawKeyCombinations[i] in this.KeybindsByKey))
			{
				this.KeybindsByKey[rawKeyCombinations[i]] = [];
			}
			this.KeybindsByKey.push(keybind);
		}
	}

	updateKeybind( _modID, _id, _keyCombinations )
	{
		// Assumes keybind has been given a function
		var keybind = this.KeybindsByMod[_modID][_id];
		var rawKeyCombinations = keybind.getRawKeyCombinations();
		for (var i = 0; i < rawKeyCombinations.length; i++) {
			this.KeybindsByKey[rawKeyCombinations[i]].splice(this.KeybindsByKey[rawKeyCombinations[i]].indexOf(keybind), 1);
			if (this.KeybindsByKey[rawKeyCombinations[i]].len() == 0)
			{
				delete this.KeybindsByKey[rawKeyCombinations[i]];
			}
		}
		this.addKeybindToKeybindsByKey(keybind);
	}

	call(key, _event, _keyState)
	{
		if (!(key in this.KeybindsByKey))
		{
			return;
		}
		for (var i = 0; i < this.KeybindsByKey[key].length; i++)
		{
			if (!this.KeybindsByKey[key][i].callOnKeyState(_keyState))
			{
				continue;
			}

			if (this.KeybindsByKey[key][i].callFunction(_event) === false)
			{
				return false;
			}
		}
	}

	onInput( _keyAsString, _event, _keyState )
	{
		var key = '';
		Object.keys(this.PressedKeys).foreach(pressedKeyID =>
		{
			if (_keyAsString != pressedKeyID)
			{
				key += pressedKeyID + "+";
			}
		});
		key += _keyAsString;
		return this.call(key, _event, _keyState);
	}

	isKeyStateContinuous( _key, _release )
	{
		if (!_release)
		{
			if (_key in this.PressedKeys)
			{
				return true;
			}
			this.PressedKeys[_key] <- 1;
		}
		else
		{
			if (_key in this.PressedKeys)
			{
				delete this.PressedKeys[_key];
			}
		}
		return false;
	}
}
