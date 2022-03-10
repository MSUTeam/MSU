this.MSU.CustomKeybinds <- {
    KeyMapSQ = {}, //see below this table
    KeyMapJS = {},  //see below this table
	CustomBindsSQ = {},
	CustomBindsJS = {}, //JS and SQ use different binds
    BindsToParse = [],

    function parseModifiers( _key )
    {
        //reorder modifiers so that they are always in the same order
        local key = "";
        local keyArray = split(_key, "+");
        local mainKey = keyArray.pop();
        if (keyArray.len() > 1)
        {
        	keyArray.sort();
        	key = keyArray.reduce(@(a, b) a + "+" + b) + "+";
        }
        else if (keyArray.len() == 1)
        {
        	key = keyArray[0] + "+";
        }

        key += mainKey;
        return key;
    }

    function get( _actionID, _defaultKey, _inSQ = true )
    {
        local environment = _inSQ ? this.CustomBindsSQ : this.CustomBindsJS;
        ::printWarning("Getting key for ID " + _actionID, this.MSU.ID, "keybinds");
        if (_actionID in environment)
        {
            ::printWarning(format("Returning key %s for ID %s.", environment[_actionID], _actionID), this.MSU.ID, "keybinds");
            return environment[_actionID];
        }
        ::printWarning(format("Returning default key %s for ID %s.", _defaultKey, _actionID), this.MSU.ID, "keybinds");
        return _defaultKey;
    }

    function has( _actionID, _inSQ = true )
    {
        local environment = _inSQ ? this.CustomBindsSQ : this.CustomBindsJS;
        return _actionID in environment;
    }

	function set( _actionID, _key, _override = false, _inSQ = true )
    {
		
		if ((typeof _actionID != "string") || (typeof _key != "string"))
        {
			this.logError(format("Trying to bind key " + _key + " to action " + _actionID + " but either is not a string!"));
		}

        local key = this.parseModifiers(_key);
        ::printWarning("Set "  + _actionID + " with key " + key + " in env ", this.MSU.ID, "keybinds");
		local environment = _inSQ ? this.CustomBindsSQ : this.CustomBindsJS;
		if ( _actionID in environment && !_override )
        {
			this.logError(format("Trying to bind key %s to action %s but is already bound and override not specified!", key, _actionID));
			return;
		}
        environment[_actionID] <- key;
        if (_inSQ) this.MSU.GlobalKeyHandler.updateHandlerFunction(_actionID, key);
		
	}

    function setForJS( _actionID, _key, _override = false )
    {
        this.set(_actionID, _key, _override, false);
    }

	function remove( _actionID, _inSQ = true )
    {
		::printWarning("Removing  keybinds for ID " + _actionID, this.MSU.ID, "keybinds");
		local environment = _inSQ ? this.CustomBindsSQ : this.CustomBindsJS;
		environment.rawdelete(_actionID);
	}

    function parseForUI()
    {
        //parses keybinds for the settings page
        foreach (mod in this.BindsToParse)
        {
            local modName = mod[0];
            local bindsArray = mod[1];
            local panel;
            local page;
            if (this.MSU.System.ModSettings.has(modName))
            {
                panel = this.MSU.System.ModSettings.get(modName);
            }
            else 
            {
                panel = this.MSU.Class.SettingsPanel(modName);
                this.MSU.System.ModSettings.add(panel);
            }
            if (panel.hasPage("Keybinds"))
            {
                page = panel.getPage("Keybinds");
            }
            else 
            {
                page = this.MSU.Class.SettingsPage("Keybinds");
                panel.addPage(page);
            }
            foreach (bind in bindsArray)
            {
                
                local id = bind.id;
                local key = this.MSU.CustomKeybinds.get(id, bind.key);
                local name = bind.name;
                local setting = this.MSU.Class.StringSetting(id, key, name);
                setting.addCallback(function(_data){
                    this.MSU.CustomKeybinds.set(id, _data, true);
                    this.MSU.PersistentDataManager.writeToLog("Keybind", modName, format("%s;%s", id, _data));
                })
                setting.setParseChange(false);
                page.add(setting);
            }   
        }
    }
}





