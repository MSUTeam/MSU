this.MSU.CustomKeybinds <- {
    KeyMapSQ = {}, //see below this table
    KeyMapJS = {},  //see below this table
	CustomBindsSQ = {},
	CustomBindsJS = {}, //JS and SQ use different binds
    BindsToParse = [],

    function ParseModifiers( _key )
    {
        //reorder modifiers so that they are always in the same order
        local keyArray = split(_key, "+");
        local key = keyArray.pop();
        local parsedKey = "";
        local findAndAdd = function( _arr, _key )
        {
            if (_arr.find(_key) != null)
            {
                parsedKey += _key + "+";
                return;
            }
        }
        findAndAdd(keyArray, "shift");
        findAndAdd(keyArray, "ctrl");
        findAndAdd(keyArray, "alt");
        parsedKey += key;
        return parsedKey;
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

        local key = this.ParseModifiers(_key);
        ::printWarning("Set "  + _actionID + " with key " + key + " in env ", this.MSU.ID, "keybinds");
		local environment = _inSQ ? this.CustomBindsSQ : this.CustomBindsJS;
		if ( _actionID in environment && !_override )
        {
			this.logError(format("Trying to bind key %s to action %s but is already bound and override not specified!", key, _actionID));
			return;
		}
        environment[_actionID] <- key;
        if (_inSQ) this.MSU.GlobalKeyHandler.UpdateHandlerFunction(_actionID, key);
		
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

this.MSU.CustomKeybinds.KeyMapSQ <- {
    "1" : "1",
    "2" : "2",
    "3" : "3",
    "4" : "4",
    "5" : "5",
    "6" : "6",
    "7" : "7",
    "8" : "8",
    "9" : "9",
    "10" : "0",
    "11" : "a",
    "12" : "b",
    "13" : "c",
    "14" : "d",
    "15" : "e",
    "16" : "f",
    "17" : "g",
    "18" : "h",
    "19" : "i",
    "20" : "j",
    "21" : "k",
    "22" : "l",
    "23" : "m",
    "24" : "n",
    "25" : "o",
    "26" : "p",
    "27" : "q",
    "28" : "r",
    "29" : "s",
    "30" : "t",
    "31" : "u",
    "32" : "v",
    "33" : "w",
    "34" : "x",
    "35" : "y",
    "36" : "z",
    "37" : "backspace",
    "38" : "tab",
    "39" : "enter",
    "40" : "space",
    "41" : "escape",
    "44" : "end",
    "45" : "home",
    "46" : "pagedown",
    "47" : "pageup",
    "48" : "left",
    "49" : "up",
    "50" : "right",
    "51" : "down",
    "53" : "insert",
    "54" : "delete",
    "55" : "n0",
    "56" : "n1",
    "57" : "n2",
    "58" : "n3",
    "59" : "n4",
    "60" : "n5",
    "61" : "n6",
    "62" : "n7",
    "63" : "n8",
    "64" : "n9",
    "66" : "*",
    "67" : "+",
    "68" : "-",
    "70" : "/",
    "71" : "f1",
    "72" : "f2",
    "73" : "f3",
    "74" : "f4",
    "75" : "f5",
    "76" : "f6",
    "77" : "f7",
    "78" : "f8",
    "79" : "f9",
    "80" : "f10",
    "81" : "f11",
    "82" : "f12",
    "83" : "f13",
    "84" : "f14",
    "85" : "f15",
    "86" : "f16",
    "87" : "f17",
    "88" : "f18",
    "89" : "f19",
    "90" : "f20",
    "91" : "f21",
    "92" : "f22",
    "93" : "f23",
    "94" : "f24",
    "95" : "ctrl",
    "96" : "shift",
    "97" : "alt",
}

this.MSU.CustomKeybinds.KeyMapSQMouse <- {
    "1" : "leftclick",
    "2" : "rightclick",
}

