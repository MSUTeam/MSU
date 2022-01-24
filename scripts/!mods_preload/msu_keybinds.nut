local gt = this.getroottable();

gt.MSU.setupCustomKeybinds <- function() {
	::mods_registerJS("msu_keybinds.js")
    ::mods_hookNewObject("states/world_state", function(o){
        local world_keyFunc = o.helper_handleContextualKeyInput;
        o.helper_handleContextualKeyInput = function(_key){
            if(_key.getState() != 0) return world_keyFunc(_key) 
            local customHandling = this.MSU.GlobalKeyHandler.ProcessInput(_key, this, true)
            if(customHandling == false){
                return false
            }
            return world_keyFunc(_key)  
        }
    })

    ::mods_hookNewObject("states/tactical_state", function(o){
        local tactical_keyFunc = o.helper_handleContextualKeyInput;
        o.helper_handleContextualKeyInput = function(_key){
            if(_key.getState() != 0) return tactical_keyFunc(_key) 
            local customHandling = this.MSU.GlobalKeyHandler.ProcessInput(_key, this, false)
            if(customHandling == false){
                return false
            }
            return tactical_keyFunc(_key)  
        }
    })
    gt.MSU.GlobalKeyHandler <- {
        HandlerFunctions = {},
        HandlerFunctionsMap = {},
        AddHandlerFunction = function(_key, _id, _func, _worldmap = true){
            //adds a new handler function entry, key is the pressed key + modifiers, ID is used to check for custom binds and to modify/remove them
            local parsedKey = this.MSU.CustomKeybinds.get(_id, _key)
            if (!(parsedKey in this.HandlerFunctions)){
               this.HandlerFunctions[parsedKey] <- []
            }
            this.HandlerFunctions[parsedKey].insert(0, {
                ID = _id,
                Func = _func,
                Worldmap = _worldmap,
                Key = parsedKey
            })
            this.HandlerFunctionsMap[_id] <- this.HandlerFunctions[parsedKey][0]
        },
        RemoveHandlerFunction = function(_key, _id){
            if(!(_id in this.HandlerFunctionsMap)){
                this.logError("ID not found")
                return
            }
            local handlerFunc = this.HandlerFunctionsMap[_id]
            this.HandlerFunctions[handlerFunc.Key].remove(this.HandlerFunctions[handlerFunc.Key].find(handlerFunc))
            this.HandlerFunctions.rawdelete(handlerFunc.Key)
            //remove handler function, for example if screen is destroyed   
        },
        UpdateHandlerFunction = function(_key, _id){
            //for when new custom binds are added after handler functions have already been added, for whatever reason
            if(!(_id in this.HandlerFunctionsMap)){
                this.logError("ID not found")
                return
            }
            local handlerFunc = this.HandlerFunctionsMap[_id]
            this.RemoveHandlerFunction(handlerFunc.Key, handlerFunc.ID)
            this.AddHandlerFunction(_key, _id, handlerFunc.Func)
        },
        CallHandlerFunction = function(_key, _env, _worldmap){ 
            // call all handler functions if they are present for the key+modifier, if one returns false execution ends
            // executed in order of last added
            if (!(_key in this.HandlerFunctions)) return
            local keyFuncArray = this.HandlerFunctions[_key]
            foreach (entry in keyFuncArray) {
                if (entry.Worldmap != _worldmap){
                    continue;
                }
                if (entry.Func.call(_env) == false){
                    return false
                }
            }
        },
        ProcessInput = function(_key, _env, _worldmap){
            local key = this.MSU.CustomKeybinds.KeyMapSQ[_key.getKey().tostring()]
            if (_key.getModifier() == 2){
                key += "+shift"
            }
            if (_key.getModifier() == 1){
                key += "+ctrl"
            }
            if (_key.getModifier() == 3){
                key += "+alt"
            }
            return MSU.GlobalKeyHandler.CallHandlerFunction(key, _env, _worldmap)
        }
    }


	gt.MSU.CustomKeybinds <- {
		KeyMapSQ = {
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
        },
		CustomBindsJS = {}, //JS and SQ use different binds
		CustomBindsSQ = {},
        ParseModifiers = function(_key){
            //reorder modifiers so that they are always in the same order
            local keyArray = split(_key, "+")
            local parsedKey = keyArray[0];
            local findAndAdd = function(_arr, _key){
                if (_arr.find(_key) != null){
                    parsedKey += "+" + _key
                    return
                }
            }
            findAndAdd(keyArray, "shift")
            findAndAdd(keyArray, "ctrl")
            findAndAdd(keyArray, "alt")
            return parsedKey
        },
        get = function(_actionID, _defaultKey, _inSQ = true){
            local environment = _inSQ ? this.CustomBindsSQ : this.CustomBindsJS;
            ::printWarning("Getting key for ID " + _actionID, this.MSU.MSUModName, "keybinds")
            if (_actionID in environment){
                ::printWarning(format("Returning key %s for ID %s.", environment[_actionID], _actionID), this.MSU.MSUModName, "keybinds");
                return environment[_actionID]
            }
            ::printWarning(format("Returning default key %s for ID %s.", _defaultKey, _actionID), this.MSU.MSUModName, "keybinds");
            return _defaultKey
        },
		set = function(_actionID, _key, _inSQ = true, _override = false){
			
			if ((typeof _actionID != "string") || (typeof _key != "string")){
				this.logError(format("Trying to bind key " + _key + " to action " + _actionID + " but either is not a string!"));
			}
            local key = this.ParseModifiers(_key)
			local environment = _inSQ ? this.CustomBindsSQ : this.CustomBindsJS;
			if (_actionID in environment && !_override){
				this.logError(format("Trying to bind key %s to action %s but is already bound and override not specified!", key, _actionID));
				return
			}
			if(_override){
				::printWarning("Override specified", this.MSU.MSUModName, "keybinds");
			}
			environment[_actionID] <- key;
            if(_inSQ) this.MSU.GlobalKeyHandler.UpdateHandlerFunction(key, _actionID);
			
		},
		remove = function(_actionID, _inSQ = true){
			local environment = _inSQ ? this.CustomBindsSQ : this.CustomBindsJS;
			::printWarning("Removing  keybinds for ID " + _actionID, this.MSU.MSUModName, "keybinds")
			environment.rawdelete(_actionID)
		},
	}

	local customKeybindsArray = this.IO.enumerateFiles("mod_config/keybinds/"); //returns either null if not valid path or no files, otherwise array with strings
	if (customKeybindsArray != null){
		foreach (filename in customKeybindsArray){
			this.include(filename);
		}
	}
	if (this.MSU.Debug.isEnabledForMod(this.MSU.MSUModName,"keybinds")){
		gt.MSU.CustomKeybinds.set("testKeybind", "3+shift", false); //set new key in JS
		gt.MSU.CustomKeybinds.set("testKeybind", "f1"); //set new key in SQ
		gt.MSU.CustomKeybinds.get("testKeybind", "f2"); //get key, returns f1
		gt.MSU.CustomKeybinds.get("wrongActionID", "f2"); //get key, returns default key f2 as actionID not bound

		gt.MSU.CustomKeybinds.set("testKeybind", "f3"); //override not specified
		gt.MSU.CustomKeybinds.set("testKeybind", "f3", true, true); //override specified

        gt.MSU.GlobalKeyHandler.AddHandlerFunction("c", "world_toggleCharacterMenu", function(){
            this.toggleCharacterScreen();
            return false
        })
        local character_toggleCharacterMenu = function(){
            if(!this.isInCharacterScreen) return true
            this.toggleCharacterScreen();
            return false
        }
        gt.MSU.GlobalKeyHandler.AddHandlerFunction("c", "character_toggleCharacterMenu_1", character_toggleCharacterMenu)
        gt.MSU.GlobalKeyHandler.AddHandlerFunction("i", "character_toggleCharacterMenu_2", character_toggleCharacterMenu)
        gt.MSU.GlobalKeyHandler.AddHandlerFunction("esc", "character_toggleCharacterMenu_3", character_toggleCharacterMenu)
        local switchPreviousBrother = function(){
           if(!this.isInCharacterScreen) return true
            this.m.CharacterScreen.switchToPreviousBrother();
            return false
        }
        gt.MSU.GlobalKeyHandler.AddHandlerFunction("left", "character_switchToPreviousBrother_1", switchPreviousBrother)
        gt.MSU.GlobalKeyHandler.AddHandlerFunction("a", "character_switchToPreviousBrother_2", switchPreviousBrother)
        local switchNextBrother = function(){
           if(!this.isInCharacterScreen) return true
            this.m.CharacterScreen.switchToNextBrother();
            return false
        }
        gt.MSU.GlobalKeyHandler.AddHandlerFunction("right", "character_switchToNextBrother_1", switchNextBrother)
        gt.MSU.GlobalKeyHandler.AddHandlerFunction("d", "character_switchToNextBrother_2", switchNextBrother)
        gt.MSU.GlobalKeyHandler.AddHandlerFunction("tab", "character_switchToNextBrother_3", switchNextBrother)

        local function isCampfireScreen(){
            return this.m.CampfireScreen != null && this.m.CampfireScreen.isVisible()
        }
        local function world_closeCampfireScreen(){
            if (!isCampfireScreen.call(this)) return true
            this.m.CampfireScreen.onModuleClosed();
            return false
        }
        gt.MSU.GlobalKeyHandler.AddHandlerFunction("p", "world_closeCampfireScreen_1", world_closeCampfireScreen)
        gt.MSU.GlobalKeyHandler.AddHandlerFunction("escape", "world_closeCampfireScreen_2", world_closeCampfireScreen)
        local function isCampfireScreen(){
            return this.m.CampfireScreen != null && this.m.CampfireScreen.isVisible()
        }

        gt.MSU.GlobalKeyHandler.AddHandlerFunction("escape", "world_toggleMenuScreen", function(){
            if (isCampfireScreen.call(this)) return true
            return (!this.toggleMenuScreen())
        })
        local function world_toggleCharacterScreen(){
            if (!this.m.MenuStack.hasBacksteps() || this.m.CharacterScreen.isVisible() || this.m.WorldTownScreen.isVisible() && !this.m.EventScreen.isVisible())
            {
                if (!this.m.EventScreen.isVisible() && !this.m.EventScreen.isAnimating())
                {
                    this.toggleCharacterScreen();
                    return false;
                }
            }
            return true
        }
        gt.MSU.GlobalKeyHandler.AddHandlerFunction("c", "world_toggleCharacterScreen_1", world_toggleCharacterScreen)
        gt.MSU.GlobalKeyHandler.AddHandlerFunction("i", "world_toggleCharacterScreen_2", world_toggleCharacterScreen)

        gt.MSU.GlobalKeyHandler.AddHandlerFunction("r", "world_toggleRelationScreen", function(){
            if (!this.m.MenuStack.hasBacksteps() && !this.m.EventScreen.isVisible() && !this.m.EventScreen.isAnimating())
            {
                this.topbar_options_module_onRelationsButtonClicked();
                return false
            }
            else if (this.m.RelationsScreen.isVisible())
            {
                this.m.RelationsScreen.onClose();
                return false
            }
            return true
        })
        gt.MSU.GlobalKeyHandler.AddHandlerFunction("o", "world_toggleObituarysScreen", function(){
            if (!this.m.MenuStack.hasBacksteps() && !this.m.EventScreen.isVisible() && !this.m.EventScreen.isAnimating())
            {
                this.topbar_options_module_onObituaryButtonClicked();
                return false
            }
            else if (this.m.ObituaryScreen.isVisible())
            {
                this.m.ObituaryScreen.onClose();
                return false
            }
            return true
        })
        gt.MSU.GlobalKeyHandler.AddHandlerFunction("t", "world_toggleCamping", function(){
            if (!this.m.MenuStack.hasBacksteps())
            {
                if (this.isCampingAllowed())
                {
                    this.onCamp();
                    return false
                }
            }
            return true
        })

        gt.MSU.GlobalKeyHandler.AddHandlerFunction("t", "world_togglePerksButton", function(){
            if (!this.m.MenuStack.hasBacksteps() && !this.m.EventScreen.isVisible() && !this.m.EventScreen.isAnimating())
            {
                this.topbar_options_module_onPerksButtonClicked();
                return false
            }
            return true
        })

	}
}
