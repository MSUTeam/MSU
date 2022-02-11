local gt = this.getroottable();

gt.MSU.setupCustomKeybinds <- function() {
	::mods_registerJS("msu_keybinds.js");
    ::mods_hookExactClass("states/world_state", function(o){
        local world_keyFunc = o.onKeyInput;
        o.onKeyInput = function(_key){
            if(_key.getState() != 0) return world_keyFunc(_key) 
            local customHandling = this.MSU.GlobalKeyHandler.ProcessInput(_key, this, this.MSU.GlobalKeyHandler.States.World)
            if(customHandling == false){
                return false
            }
            return world_keyFunc(_key)  
        }
        local world_mouseInput = o.onMouseInput
        o.onMouseInput = function(_mouse){
            if(_mouse.getState() != 1 || _mouse.getID() == 6) return world_mouseInput(_mouse)
            local customHandling = this.MSU.GlobalKeyHandler.ProcessInput(_mouse, this, this.MSU.GlobalKeyHandler.States.World, this.MSU.GlobalKeyHandler.InputType.Mouse)
            if(customHandling == false){
                return false
            }
            return world_mouseInput(_mouse)
        }
    })

    ::mods_hookExactClass("states/tactical_state", function(o){

        local tactical_keyFunc = o.onKeyInput;
        o.onKeyInput = function(_key){
            if(_key.getState() != 0 || this.isInLoadingScreen() || this.isBattleEnded()) return tactical_keyFunc(_key) 
            local customHandling = this.MSU.GlobalKeyHandler.ProcessInput(_key, this, this.MSU.GlobalKeyHandler.States.Tactical)
            if(customHandling == false){
                return false
            }
            return tactical_keyFunc(_key)  
        }
        local tactical_mouseInput = o.onMouseInput
        o.onMouseInput = function(_mouse){
            if(_mouse.getState() != 1 || _mouse.getID() == 6) return tactical_mouseInput(_mouse)
            local customHandling = this.MSU.GlobalKeyHandler.ProcessInput(_mouse, this, this.MSU.GlobalKeyHandler.States.Tactical, this.MSU.GlobalKeyHandler.InputType.Mouse)
            if(customHandling == false){
                return false
            }
            return tactical_mouseInput(_mouse)
        }
    })
    ::mods_hookExactClass("states/main_menu_state", function(o){
        local menu_onKeyInput = o.onKeyInput
        o.onKeyInput = function(_key){
            if(_key.getState() != 0) return menu_onKeyInput(_key) 
            local customHandling = this.MSU.GlobalKeyHandler.ProcessInput(_key, this, this.MSU.GlobalKeyHandler.States.MainMenu)
            if(customHandling == false){
                return false
            }
            return menu_onKeyInput(_key)
        }
        //menu mouse input  somehow doesn't register any ID but 6 (movement)
        local menu_mouseInput = o.onMouseInput
        o.onMouseInput = function(_mouse){
            if(_mouse.getState() != 1 || _mouse.getID() == 6) return menu_mouseInput(_mouse)
            local customHandling = this.MSU.GlobalKeyHandler.ProcessInput(_mouse, this, this.MSU.GlobalKeyHandler.States.MainMenu, this.MSU.GlobalKeyHandler.InputType.Mouse)
            if(customHandling == false){
                return false
            }
            return menu_mouseInput(_mouse)
        }
    })
    gt.MSU.GlobalKeyHandler <- {
        HandlerFunctions = {},
        HandlerFunctionsMap = {},
        States = {
            World = 0,
            Tactical = 1,
            MainMenu = 2,
            All = 4
        },
        InputType = {
            Keyboard = 0,
            Mouse = 1
        },
        AddHandlerFunction = function(_id, _key,  _func, _state = 0){
            //adds a new handler function entry, key is the pressed key + modifiers, ID is used to check for custom binds and to modify/remove them
            local parsedKey = this.MSU.CustomKeybinds.get(_id, _key)
            if (!(parsedKey in this.HandlerFunctions)){
               this.HandlerFunctions[parsedKey] <- []
            }
            this.HandlerFunctions[parsedKey].insert(0, {
                ID = _id,
                Func = _func,
                State = _state,
                Key = parsedKey
            })
            this.HandlerFunctionsMap[_id] <- this.HandlerFunctions[parsedKey][0]
        },
        RemoveHandlerFunction = function(_id, _key){
            if(!(_id in this.HandlerFunctionsMap)){
                ::printWarning("ID " + _id + " not found in Handlerfunctions!", this.MSU.MSUModName, "keybinds");
                return
            }
            local handlerFunc = this.HandlerFunctionsMap[_id]
            this.HandlerFunctions[handlerFunc.Key].remove(this.HandlerFunctions[handlerFunc.Key].find(handlerFunc))
            if(this.HandlerFunctions[handlerFunc.Key].len() == 0){
                this.HandlerFunctions.rawdelete(handlerFunc.Key)
            }
            this.HandlerFunctionsMap.rawdelete(handlerFunc.Key)
            //remove handler function, for example if screen is destroyed   
        },
        UpdateHandlerFunction = function(_id, _key){
            //for when new custom binds are added after handler functions have already been added, for whatever reason
            if(!(_id in this.HandlerFunctionsMap)){
                ::printWarning("ID " + _id + " not found in Handlerfunctions!", this.MSU.MSUModName, "keybinds");
                return
            }
            local handlerFunc = this.HandlerFunctionsMap[_id]
            this.RemoveHandlerFunction(handlerFunc.ID, handlerFunc.Key)
            this.AddHandlerFunction(_id, _key, handlerFunc.Func, handlerFunc.State)
        },
        CallHandlerFunction = function(_key, _env, _state){ 
            ::printWarning(format("Checking handler function for key %s", _key), this.MSU.MSUModName, "keybinds");
            // call all handler functions if they are present for the key+modifier, if one returns false execution ends
            // executed in order of last added
            if (!(_key in this.HandlerFunctions)){
                return
            }
            local keyFuncArray = this.HandlerFunctions[_key];
            foreach (entry in keyFuncArray) {
                ::printWarning(format("Checking handler function for key %s for ID %s", entry.Key, entry.ID), this.MSU.MSUModName, "keybinds");
                ::printWarning("State " + entry.State, this.MSU.MSUModName, "keybinds");
                if (entry.State != this.States.All && entry.State != _state){
                    continue;
                }
                ::printWarning(format("Calling handler function for key %s for ID %s.", entry.Key, entry.ID), this.MSU.MSUModName, "keybinds");
                if (entry.Func.call(_env) == false){
                    return false
                }
            }
        },
        ProcessInput = function(_key, _env, _state, _inputType = 0){
            local key;
            if(_inputType == this.InputType.Keyboard){
                local keyAsString = _key.getKey().tostring();
                if (!(keyAsString in this.MSU.CustomKeybinds.KeyMapSQ)){
                    this.logWarning("Unknown key pressed! Key: " + _key.getKey());
                    return
                }
                key = this.MSU.CustomKeybinds.KeyMapSQ[_key.getKey().tostring()];
                if (_key.getModifier() == 2){
                    key += "+ctrl";
                }
                if (_key.getModifier() == 1){
                    key += "+shift";
                }
                if (_key.getModifier() == 3){
                    key += "+alt";
                }
            }
            else if(_inputType == this.InputType.Mouse){
                local keyAsString = _key.getID().tostring();
                if (!(keyAsString in this.MSU.CustomKeybinds.KeyMapSQMouse)){
                    this.logWarning("Unknown mouse key pressed! Key: " + _key.getID());
                    return
                }
                key = this.MSU.CustomKeybinds.KeyMapSQMouse[_key.getID().tostring()];
            }
            else{
                this.logError(_inputType + " is not a valid input type!");
                return
            }
            return MSU.GlobalKeyHandler.CallHandlerFunction(key, _env, _state)
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
        KeyMapSQMouse = {
            "1" : "leftclick",
            "2" : "rightclick",
        },
		CustomBindsJS = {}, //JS and SQ use different binds
		CustomBindsSQ = {},
        BindsToParse = [],
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
        has = function(_actionID, _inSQ = true){
            local environment = _inSQ ? this.CustomBindsSQ : this.CustomBindsJS;
            return _actionID in environment
        },

		set = function(_actionID, _key, _override = false, _inSQ = true){
			
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
            ::printWarning("Set "  + _actionID + " with key " + key + " in env ", this.MSU.MSUModName, "keybinds");
            if(_inSQ) this.MSU.GlobalKeyHandler.UpdateHandlerFunction(_actionID, key);
			
		},
        setForJS = function(_actionID, _key, _override = false){
            this.set(_actionID, _key, _override, false)
        },
		remove = function(_actionID, _inSQ = true){
			local environment = _inSQ ? this.CustomBindsSQ : this.CustomBindsJS;
			::printWarning("Removing  keybinds for ID " + _actionID, this.MSU.MSUModName, "keybinds")
			environment.rawdelete(_actionID)
		},
        parseForUI = function(){
            foreach(mod in this.BindsToParse){
                local modName = mod[0]
                local bindsArray = mod[1]
                local panel;
                local page;
                if(this.MSU.SettingsManager.has(modName)){
                    panel = this.MSU.SettingsManager.get(modName)
                }
                else{
                    panel = this.MSU.SettingsPanel(modName);
                    this.MSU.SettingsManager.add(panel)
                }
                if (panel.has("Keybinds")){
                    page = panel.getPage("Keybinds")
                }
                else{
                    page = this.MSU.SettingsPage("Keybinds");
                    panel.add(page)
                }
                foreach(bind in bindsArray){
                    
                    local id = bind.id
                    local key = this.MSU.CustomKeybinds.get(id, bind.key)
                    local name = bind.name
                    local setting = this.MSU.StringSetting(id, key, name);
                    setting.addCallback(function(_data){
                        this.MSU.CustomKeybinds.set(id, _data, true)
                        this.MSU.PersistentDataManager.writeToLog("Keybind", modName, format("%s;%s", id, _data))
                    })
                    setting.setPrintChange(false);
                    page.add(setting)
                }   
            }
        }
	}

    this.MSU.CustomKeybinds.BindsToParse.push(["Vanilla",
       [
            {
                id = "character_toggleCharacterMenu_1",
                key = "c",
                name = "character_toggleCharacterMenu_1"
            },
            {
                id = "character_toggleCharacterMenu_2",
                key = "i",
                name = "character_toggleCharacterMenu_2"
            },
            {
                id = "character_toggleCharacterMenu_3",
                key = "escape",
                name = "character_toggleCharacterMenu_3"
            }
        ]
    ])
    this.MSU.CustomKeybinds.BindsToParse.push(["MSU",
       [
            {
                id = "test",
                key = "c",
                name = "test"
            },
            {
                id = "test2",
                key = "i",
                name = "test2"
            },
            {
                id = "test3",
                key = "escape",
                name = "test3"
            }
        ]
    ])
    this.MSU.CustomKeybinds.BindsToParse.push(["Vanilla",
       [
            {
                id = "test",
                key = "c",
                name = "test"
            },
            {
                id = "test2",
                key = "i",
                name = "test2"
            },
            {
                id = "test3",
                key = "escape",
                name = "test3"
            }
        ]
    ])


// --------------------------------------------- LOADING CUSTOM KEYBINDS -------------------------------------------------------

	

// --------------------------------------------- ADDING VANILLA HANDLERS -------------------------------------------------------
    
    local character_toggleCharacterMenu = function(){
            if(!this.isInCharacterScreen()) return
            this.toggleCharacterScreen();
            return false
        }

    gt.MSU.GlobalKeyHandler.AddHandlerFunction("character_toggleCharacterMenu_1", "c",  character_toggleCharacterMenu)
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("character_toggleCharacterMenu_2", "i",  character_toggleCharacterMenu)
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("character_toggleCharacterMenu_3", "escape",  character_toggleCharacterMenu)
    local switchPreviousBrother = function(){
       if(!this.isInCharacterScreen()) return
        this.m.CharacterScreen.switchToPreviousBrother();
        return false
    }
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("character_switchToPreviousBrother_1", "left",  switchPreviousBrother)
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("character_switchToPreviousBrother_2", "a",  switchPreviousBrother)
    local switchNextBrother = function(){
       if(!this.isInCharacterScreen()) return
        this.m.CharacterScreen.switchToNextBrother();
        return false
    }
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("character_switchToNextBrother_1", "right",  switchNextBrother)
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("character_switchToNextBrother_2", "d",  switchNextBrother)
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("character_switchToNextBrother_3", "tab",  switchNextBrother)

    local function isCampfireScreen(){
        return this.m.CampfireScreen != null && this.m.CampfireScreen.isVisible()
    }
    local function world_closeCampfireScreen(){
        if (!isCampfireScreen.call(this)) return
        this.m.CampfireScreen.onModuleClosed();
        return false
    }
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_closeCampfireScreen_1", "p",  world_closeCampfireScreen)
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_closeCampfireScreen_2", "escape",  world_closeCampfireScreen)

    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_toggleMenuScreen", "escape",  function(){
        if (isCampfireScreen.call(this)) return
        if (this.toggleMenuScreen())
        {
            return false;
        }
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
    }
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_toggleCharacterScreen_1", "c",  world_toggleCharacterScreen)
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_toggleCharacterScreen_2", "i",  world_toggleCharacterScreen)

    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_toggleRelationScreen", "r",  function(){
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
    })
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_toggleObituarysScreen", "o",  function(){
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
    })
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_toggleCamping", "t",  function(){
        if (!this.m.MenuStack.hasBacksteps())
        {
            if (this.isCampingAllowed())
            {
                this.onCamp();
                return false
            }
        }
    })

    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_toggleRetinueButton", "p",  function(){
        if (!this.m.MenuStack.hasBacksteps() && !this.m.EventScreen.isVisible() && !this.m.EventScreen.isAnimating())
        {
            this.topbar_options_module_onPerksButtonClicked();
            return false
        }
    })

    local function world_pause(){
        if (!this.m.MenuStack.hasBacksteps())
        {
            this.setPause(!this.isPaused());
            return false;
        }
    }

    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_pause_1", "0",  world_pause)
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_pause_2", "space",  world_pause)
    //gt.MSU.GlobalKeyHandler.AddHandlerFunction("t", "world_pause_3", worldmap_pause) 42?

    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_speedNormal", "1",  function(){
        if (!this.m.MenuStack.hasBacksteps())
        {
            this.setNormalTime();
            return false;
        }
    })
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_speedFast", "2",  function(){
        if (!this.m.MenuStack.hasBacksteps())
        {
            this.setFastTime();
            return false;
        }
    })
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_trackingButton", "f",  function(){
        if (!this.m.MenuStack.hasBacksteps())
        {
            this.m.WorldScreen.getTopbarOptionsModule().onTrackingButtonPressed();
            return false;
        }
    })
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_cameraLockButton", "x",  function(){
        if (!this.m.MenuStack.hasBacksteps())
        {
            this.m.WorldScreen.getTopbarOptionsModule().onCameraLockButtonPressed();
            return false;
        }
    })
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_quicksave", "f5",  function(){
        if (!this.m.MenuStack.hasBacksteps() && !this.World.Assets.isIronman())
        {
            this.saveCampaign("quicksave");
            return false
        }
    })
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_quickload", "f9",  function(){
        if (!this.m.MenuStack.hasBacksteps() && !this.World.Assets.isIronman() && this.World.canLoad("quicksave"))
        {
            this.loadCampaign("quicksave");
            return false
        }
    })
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_event_1", "1",  function(){
        if (!this.m.EventScreen.isVisible() || this.m.EventScreen.isAnimating())
        {
            return
        }

        this.m.EventScreen.onButtonPressed(0);
        return false;
    })
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_event_2", "2",  function(){
        if (!this.m.EventScreen.isVisible() || this.m.EventScreen.isAnimating())
        {
            return
        }

        this.m.EventScreen.onButtonPressed(1);
        return false;
    })
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_event_3", "3",  function(){
        if (!this.m.EventScreen.isVisible() || this.m.EventScreen.isAnimating())
        {
            return
        }

        this.m.EventScreen.onButtonPressed(2);
        return false;
    })
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_event_4", "4",  function(){
        if (!this.m.EventScreen.isVisible() || this.m.EventScreen.isAnimating())
        {
            return
        }

        this.m.EventScreen.onButtonPressed(3);
        return false;
    })

    gt.MSU.GlobalKeyHandler.AddHandlerFunction("world_release_forceattack", "ctrl",  function(){
        this.m.IsForcingAttack = false;
    })

    //-------------------------------------------TACTICAL---------------------------------------------------------------------------------


    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_hideCharacterScreen", "enter",  function(){
        if(!this.isInCharacterScreen()) return
        if (this.m.CharacterScreen.isInBattlePreparationMode() == true)
        {
            this.hideCharacterScreen();
            return false
        }
    }, gt.MSU.GlobalKeyHandler.States.Tactical)

    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_switchPreviousBrother_1", "left",  switchPreviousBrother, gt.MSU.GlobalKeyHandler.States.Tactical)
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_switchPreviousBrother_1", "a",  switchPreviousBrother, gt.MSU.GlobalKeyHandler.States.Tactical)
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_switchNextBrother_1", "right",  switchNextBrother, gt.MSU.GlobalKeyHandler.States.Tactical)
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_switchNextBrother_2", "d",  switchNextBrother, gt.MSU.GlobalKeyHandler.States.Tactical)
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_switchNextBrother_3", "tab",  switchNextBrother, gt.MSU.GlobalKeyHandler.States.Tactical)
    
    local function hideCharacterScreen(){
        if(!this.isInCharacterScreen() || this.m.CharacterScreen.isAnimating()) return
        this.hideCharacterScreen()
        return false
    }
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_hideCharacterScreen_1", "i",  hideCharacterScreen, gt.MSU.GlobalKeyHandler.States.Tactical)
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_hideCharacterScreen_2", "c",  hideCharacterScreen, gt.MSU.GlobalKeyHandler.States.Tactical)
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_hideCharacterScreen_3", "escape",  hideCharacterScreen, gt.MSU.GlobalKeyHandler.States.Tactical)

    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_toggleMenuScreen", "escape",  function(){
        if(this.isInCharacterScreen()) return
        if (!this.m.MenuStack.hasBacksteps() || this.m.TacticalMenuScreen.isVisible())
        {
            if (this.toggleMenuScreen())
            {
                return false;
            }
        }
    }, gt.MSU.GlobalKeyHandler.States.Tactical)

    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_toggleStatsOverlays", "alt",  function(){
        if (this.m.MenuStack.hasBacksteps()) return
        this.topbar_options_onToggleStatsOverlaysButtonClicked();
        return false
    }, gt.MSU.GlobalKeyHandler.States.Tactical)

    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_toggleTreesButton", "t",  function(){
        if (this.m.MenuStack.hasBacksteps()) return
        this.topbar_options_onToggleTreesButtonClicked();
        return false
    }, gt.MSU.GlobalKeyHandler.States.Tactical)

    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_toggleHighlightBlockedTiles", "b",  function(){
        if (this.m.MenuStack.hasBacksteps()) return
        this.topbar_options_onToggleHighlightBlockedTilesButtonClicked();
        return false
    }, gt.MSU.GlobalKeyHandler.States.Tactical)

    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_initNextTurn", "enter",  function(){
        if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return
         this.Tactical.TurnSequenceBar.initNextTurn();
        return false
    }, gt.MSU.GlobalKeyHandler.States.Tactical)

    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_endTurnAll", "r",  function(){
        if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return
        this.Tactical.TurnSequenceBar.onEndTurnAllButtonPressed();
        return false
    }, gt.MSU.GlobalKeyHandler.States.Tactical)
    local function waitTurn(){
        if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return
        if (this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().isPlayerControlled())
        {
            local wasAbleToWait = this.Tactical.TurnSequenceBar.entityWaitTurn(this.Tactical.TurnSequenceBar.getActiveEntity());

            if (!wasAbleToWait)
            {
                this.Tactical.TurnSequenceBar.initNextTurn();
            }
            return false
        }
    }

    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_waitTurn_1", "end",  waitTurn, gt.MSU.GlobalKeyHandler.States.Tactical)
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_waitTurn_2", "space",  waitTurn, gt.MSU.GlobalKeyHandler.States.Tactical)

    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_focusActiveEntity", "shift",  function(){
        if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return
        this.Tactical.TurnSequenceBar.focusActiveEntity(true);
        return false
    }, gt.MSU.GlobalKeyHandler.States.Tactical)

    local function showCharacterScreen(){
        if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return
        this.showCharacterScreen();
        return false
    }

    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_showCharacterScreen_1", "i",  showCharacterScreen, gt.MSU.GlobalKeyHandler.States.Tactical)
    gt.MSU.GlobalKeyHandler.AddHandlerFunction("tactical_showCharacterScreen_2", "c",  showCharacterScreen, gt.MSU.GlobalKeyHandler.States.Tactical)

	if (this.MSU.Debug.isEnabledForMod(this.MSU.MSUModName,"keybinds")){
		gt.MSU.CustomKeybinds.setForJS("testKeybind", "3+shift"); //set new key in JS
		gt.MSU.CustomKeybinds.set("testKeybind", "f1"); //set new key in SQ
		gt.MSU.CustomKeybinds.get("testKeybind", "f2"); //get key, returns f1
		gt.MSU.CustomKeybinds.get("wrongActionID", "f2"); //get key, returns default key f2 as actionID not bound

		gt.MSU.CustomKeybinds.set("testKeybind", "f3"); //override not specified
		gt.MSU.CustomKeybinds.set("testKeybind", "f3", true); //override specified

	}
}

