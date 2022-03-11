this.MSU.Class.KeybindsSystem <- class extends this.MSU.Class.System
{
	KeybindsByKey = null;
	KeybindsByMod = null;
	KeybindsForJS = null;
	IsConnected = null;

	constructor()
	{
		base.constructor(this.MSU.SystemID.Keybinds);
		this.KeybindsByKey = {};
		this.KeybindsByMod = {};
		this.KeybindsForJS = {};
		this.IsConnected = false;
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

	function call( _key, _state, _environment )
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
			::printWarning(format("Calling handler function: key %s | ID %s | State %s", keybind.getKey(), keybind.getID(), keybind.getState().tostring()), this.MSU.ID, "keybinds");
			if (!keybind.call(_environment))
			{
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

}
