MSU.Keybinds = {
	KeybindsByKey : {},
	KeybindsByMod : {},
	PressedKeys : {},
	KeybindsToParse : {},
	addKeybindFromSQ : function( _modID, _id, _keyCombinations, _keyState )
	{
		if (_modID in this.KeybindsByMod && _id in this.KeybindsByMod[_modID] && this.KeybindsByMod[_modID][_id].isFullyInit())
		{
			this.KeybindsByMod[_modID][_id].initFromSQ(_keyCombinations, _keyState);
			this.addKeybindToKeybindsByKey(this.KeybindsByMod[_modID][_id]);
		}
		else
		{
			this.addKeybindToKeybindsByMod(new MSUKeybind(_modID, _id, null, _keyCombinations, _keyState));
		}
	},

	addKeybindFunction : function( _modID, _id, _function )
	{
		if (_modID in this.KeybindsByMod && _id in this.KeybindsByMod[_modID] && this.KeybindsByMod[_modID][_id].isFullyInit())
		{
			this.KeybindsByMod[_modID][_id].initFromJS(_function);
			this.addKeybindToKeybindsByKey(this.KeybindsByMod[_modID][_id]);
		}
		else
		{
			this.addKeybindToKeybindsByMod(new MSUKeybind(_modID, _id, _function));
		}
	},

	addKeybindToKeybindsByMod : function( _keybind )
	{
		if (!(_keybind.ModID in this.KeybindsByMod))
		{
			this.KeybindsByMod[_keybind.ModID] = {};
		}
		this.KeybindsByMod[_keybind.ModID][_keybind.ID] = _keybind;
	},

	addKeybindToKeybindsByKey : function( _keybind )
	{
		var rawKeyCombinations = _keybind.getRawKeyCombinations();
		for (var i = 0; i < rawKeyCombinations.length; i++)
		{
			if (!(rawKeyCombinations[i] in this.KeybindsByKey))
			{
				this.KeybindsByKey[rawKeyCombinations[i]] = [];
			}
			this.KeybindsByKey[rawKeyCombinations[i]].push(_keybind);
		}
	},

	removeKeybind : function( _modID, _id ) // Only removes the keybinds from potential places it could be called so that if the keybind is just getting updated it will still be available for addKeybindFromSQ
	{
		var keybind = this.KeybindsByMod[_modID][_id];
		var rawKeyCombinations = keybind.getRawKeyCombinations();
		for (var i = 0; i < rawKeyCombinations.length; i++) {
			this.KeybindsByKey[rawKeyCombinations[i]].splice(this.KeybindsByKey[rawKeyCombinations[i]].indexOf(keybind), 1);
			if (this.KeybindsByKey[rawKeyCombinations[i]].length == 0)
			{
				delete this.KeybindsByKey[rawKeyCombinations[i]];
			}
		}
	},

	call : function( key, _event, _keyState )
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
	},

	getPressedKeysAsString : function( _excludeKey )
	{
		var key = '';
		Object.keys(this.PressedKeys).forEach( function( pressedKeyID )
		{
			if (_excludeKey != pressedKeyID)
			{
				key += pressedKeyID + "+";
			}
		});
		return key;
	},

	onInput : function( _keyAsString, _event, _keyState )
	{
		var key = this.getPressedKeysAsString(_keyAsString) + _keyAsString;
		return this.call(key, _event, _keyState);
	},

	isKeyStateContinuous : function( _key, _release )
	{
		if (!_release)
		{
			if (_key in this.PressedKeys)
			{
				return true;
			}
			this.PressedKeys[_key] = 1;
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
