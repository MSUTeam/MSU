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
        {
            id = "character_switchToPreviousBrother_1",
            key = "left",
            name = "Switch to previous brother"
        },
        {
            id = "character_switchToPreviousBrother_2",
            key = "a",
            name = "Switch to previous brother"
        },
        {
            id = "character_switchToNextBrother_1",
            key = "right",
            name = "Switch to next brother"
        },
        {
            id = "character_switchToNextBrother_2",
            key = "d",
            name = "Switch to next brother"
        },
        {
            id = "character_switchToNextBrother_3",
            key = "tab",
            name = "Switch to next brother"
        },
        {
            id = "world_closeCampfireScreen_1",
            key = "tab",
            name = "Close retinue screen"
        },
        {
            id = "world_closeCampfireScreen_2",
            key = "escape",
            name = "Close retinue screen"
        },
        {
            id = "world_toggleMenuScreen",
            key = "tab",
            name = "Close Menu"
        },
        {
            id = "world_toggleCharacterScreen_1",
            key = "c",
            name = "Toggle inventory"
        },
        {
            id = "world_toggleCharacterScreen_2",
            key = "i",
            name = "Toggle inventory"
        },
        {
            id = "world_toggleRelationScreen",
            key = "r",
            name = "Toggle relations"
        },
        {
            id = "world_toggleObituarysScreen",
            key = "o",
            name = "Toggle obituary"
        },
        {
            id = "world_toggleCamping",
            key = "t",
            name = "Toggle camping"
        },
        {
            id = "world_toggleRetinueButton",
            key = "p",
            name = "Toggle retinue"
        },
        {
            id = "world_pause_1",
            key = "0",
            name = "Pause"
        },
        {
            id = "world_pause_2",
            key = "space",
            name = "Pause"
        },
        {
            id = "world_speedNormal",
            key = "1",
            name = "Normal Speed"
        },
        {
            id = "world_speedFast",
            key = "2",
            name = "Fast Speed"
        },
        {
            id = "world_trackingButton",
            key = "f",
            name = "Tracking"
        },
        {
            id = "world_cameraLockButton",
            key = "x",
            name = "Lock Camera"
        },
        {
            id = "world_quicksave",
            key = "f5",
            name = "Quicksave"
        },
        {
            id = "world_quickload",
            key = "f9",
            name = "Quickload"
        },

        {
            id = "world_event_1",
            key = "1",
            name = "Event input 1"
        },
        {
            id = "world_event_2",
            key = "2",
            name = "Event input 2"
        },
        {
            id = "world_event_3",
            key = "3",
            name = "Event input 3"
        },
        {
            id = "world_event_4",
            key = "4",
            name = "Event input 4"
        },
        {
            id = "world_release_forceattack",
            key = "ctrl",
            name = "Force Attack"
        }
    ]
])


//On the tactical map:

// this.MSU.CustomKeybinds.set("tactical_hideCharacterScreen", "enter")
// this.MSU.CustomKeybinds.set("tactical_switchPreviousBrother_1", "left")
// this.MSU.CustomKeybinds.set("tactical_switchPreviousBrother_1", "a")
// this.MSU.CustomKeybinds.set("tactical_switchNextBrother_1", "right")
// this.MSU.CustomKeybinds.set("tactical_switchNextBrother_2", "d")
// this.MSU.CustomKeybinds.set("tactical_switchNextBrother_3", "tab"))
// this.MSU.CustomKeybinds.set("tactical_hideCharacterScreen_1", "i")
// this.MSU.CustomKeybinds.set("tactical_hideCharacterScreen_2", "c")
// this.MSU.CustomKeybinds.set("tactical_hideCharacterScreen_3", "escape")
// this.MSU.CustomKeybinds.set("tactical_toggleMenuScreen", "escape")
// this.MSU.CustomKeybinds.set("tactical_toggleStatsOverlays", "alt")
// this.MSU.CustomKeybinds.set("tactical_toggleTreesButton", "t")
// this.MSU.CustomKeybinds.set("tactical_toggleHighlightBlockedTiles", "b")
// this.MSU.CustomKeybinds.set("tactical_initNextTurn", "enter")
// this.MSU.CustomKeybinds.set("tactical_endTurnAll", "r")
// this.MSU.CustomKeybinds.set("tactical_waitTurn_1", "end")
// this.MSU.CustomKeybinds.set("tactical_waitTurn_2", "space")
// this.MSU.CustomKeybinds.set("tactical_focusActiveEntity", "shift")
// this.MSU.CustomKeybinds.set("tactical_showCharacterScreen_1", "i")
// this.MSU.CustomKeybinds.set("tactical_showCharacterScreen_2", "c")


// --------------------------------------------- LOADING CUSTOM KEYBINDS -------------------------------------------------------



// --------------------------------------------- ADDING VANILLA HANDLERS -------------------------------------------------------

local character_toggleCharacterMenu = function(){
        if (!this.isInCharacterScreen()) return
        this.toggleCharacterScreen();
        return false
    }

this.MSU.GlobalKeyHandler.addHandlerFunction("character_toggleCharacterMenu_1", "c",  character_toggleCharacterMenu)
this.MSU.GlobalKeyHandler.addHandlerFunction("character_toggleCharacterMenu_2", "i",  character_toggleCharacterMenu)
this.MSU.GlobalKeyHandler.addHandlerFunction("character_toggleCharacterMenu_3", "escape",  character_toggleCharacterMenu)
local switchPreviousBrother = function(){
   if (!this.isInCharacterScreen()) return
    this.m.CharacterScreen.switchToPreviousBrother();
    return false
}
this.MSU.GlobalKeyHandler.addHandlerFunction("character_switchToPreviousBrother_1", "left",  switchPreviousBrother)
this.MSU.GlobalKeyHandler.addHandlerFunction("character_switchToPreviousBrother_2", "a",  switchPreviousBrother)
local switchNextBrother = function(){
   if (!this.isInCharacterScreen()) return
    this.m.CharacterScreen.switchToNextBrother();
    return false
}
this.MSU.GlobalKeyHandler.addHandlerFunction("character_switchToNextBrother_1", "right",  switchNextBrother)
this.MSU.GlobalKeyHandler.addHandlerFunction("character_switchToNextBrother_2", "d",  switchNextBrother)
this.MSU.GlobalKeyHandler.addHandlerFunction("character_switchToNextBrother_3", "tab",  switchNextBrother)

local function isCampfireScreen(){
    return this.m.CampfireScreen != null && this.m.CampfireScreen.isVisible()
}
local function world_closeCampfireScreen(){
    if (!isCampfireScreen.call(this)) return
    this.m.CampfireScreen.onModuleClosed();
    return false
}
this.MSU.GlobalKeyHandler.addHandlerFunction("world_closeCampfireScreen_1", "p",  world_closeCampfireScreen)
this.MSU.GlobalKeyHandler.addHandlerFunction("world_closeCampfireScreen_2", "escape",  world_closeCampfireScreen)

this.MSU.GlobalKeyHandler.addHandlerFunction("world_toggleMenuScreen", "escape",  function(){
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
this.MSU.GlobalKeyHandler.addHandlerFunction("world_toggleCharacterScreen_1", "c",  world_toggleCharacterScreen)
this.MSU.GlobalKeyHandler.addHandlerFunction("world_toggleCharacterScreen_2", "i",  world_toggleCharacterScreen)

this.MSU.GlobalKeyHandler.addHandlerFunction("world_toggleRelationScreen", "r",  function(){
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
this.MSU.GlobalKeyHandler.addHandlerFunction("world_toggleObituarysScreen", "o",  function(){
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
this.MSU.GlobalKeyHandler.addHandlerFunction("world_toggleCamping", "t",  function(){
    if (!this.m.MenuStack.hasBacksteps())
    {
        if (this.isCampingAllowed())
        {
            this.onCamp();
            return false
        }
    }
})

this.MSU.GlobalKeyHandler.addHandlerFunction("world_toggleRetinueButton", "p",  function(){
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

this.MSU.GlobalKeyHandler.addHandlerFunction("world_pause_1", "0",  world_pause)
this.MSU.GlobalKeyHandler.addHandlerFunction("world_pause_2", "space",  world_pause)
//this.MSU.GlobalKeyHandler.addHandlerFunction("t", "world_pause_3", worldmap_pause) 42?

this.MSU.GlobalKeyHandler.addHandlerFunction("world_speedNormal", "1",  function(){
    if (!this.m.MenuStack.hasBacksteps())
    {
        this.setNormalTime();
        return false;
    }
})
this.MSU.GlobalKeyHandler.addHandlerFunction("world_speedFast", "2",  function(){
    if (!this.m.MenuStack.hasBacksteps())
    {
        this.setFastTime();
        return false;
    }
})
this.MSU.GlobalKeyHandler.addHandlerFunction("world_trackingButton", "f",  function(){
    if (!this.m.MenuStack.hasBacksteps())
    {
        this.m.WorldScreen.getTopbarOptionsModule().onTrackingButtonPressed();
        return false;
    }
})
this.MSU.GlobalKeyHandler.addHandlerFunction("world_cameraLockButton", "x",  function(){
    if (!this.m.MenuStack.hasBacksteps())
    {
        this.m.WorldScreen.getTopbarOptionsModule().onCameraLockButtonPressed();
        return false;
    }
})
this.MSU.GlobalKeyHandler.addHandlerFunction("world_quicksave", "f5",  function(){
    if (!this.m.MenuStack.hasBacksteps() && !this.World.Assets.isIronman())
    {
        this.saveCampaign("quicksave");
        return false
    }
})
this.MSU.GlobalKeyHandler.addHandlerFunction("world_quickload", "f9",  function(){
    if (!this.m.MenuStack.hasBacksteps() && !this.World.Assets.isIronman() && this.World.canLoad("quicksave"))
    {
        this.loadCampaign("quicksave");
        return false
    }
})
this.MSU.GlobalKeyHandler.addHandlerFunction("world_event_1", "1",  function(){
    if (!this.m.EventScreen.isVisible() || this.m.EventScreen.isAnimating())
    {
        return
    }

    this.m.EventScreen.onButtonPressed(0);
    return false;
})
this.MSU.GlobalKeyHandler.addHandlerFunction("world_event_2", "2",  function(){
    if (!this.m.EventScreen.isVisible() || this.m.EventScreen.isAnimating())
    {
        return
    }

    this.m.EventScreen.onButtonPressed(1);
    return false;
})
this.MSU.GlobalKeyHandler.addHandlerFunction("world_event_3", "3",  function(){
    if (!this.m.EventScreen.isVisible() || this.m.EventScreen.isAnimating())
    {
        return
    }

    this.m.EventScreen.onButtonPressed(2);
    return false;
})
this.MSU.GlobalKeyHandler.addHandlerFunction("world_event_4", "4",  function(){
    if (!this.m.EventScreen.isVisible() || this.m.EventScreen.isAnimating())
    {
        return
    }

    this.m.EventScreen.onButtonPressed(3);
    return false;
})

this.MSU.GlobalKeyHandler.addHandlerFunction("world_release_forceattack", "ctrl",  function(){
    this.m.IsForcingAttack = false;
})

//-------------------------------------------TACTICAL---------------------------------------------------------------------------------


this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_hideCharacterScreen", "enter",  function(){
    if (!this.isInCharacterScreen()) return
    if (this.m.CharacterScreen.isInBattlePreparationMode() == true)
    {
        this.hideCharacterScreen();
        return false
    }
}, this.MSU.GlobalKeyHandler.States.Tactical)

this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_switchPreviousBrother_1", "left",  switchPreviousBrother, this.MSU.GlobalKeyHandler.States.Tactical)
this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_switchPreviousBrother_1", "a",  switchPreviousBrother, this.MSU.GlobalKeyHandler.States.Tactical)
this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_switchNextBrother_1", "right",  switchNextBrother, this.MSU.GlobalKeyHandler.States.Tactical)
this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_switchNextBrother_2", "d",  switchNextBrother, this.MSU.GlobalKeyHandler.States.Tactical)
this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_switchNextBrother_3", "tab",  switchNextBrother, this.MSU.GlobalKeyHandler.States.Tactical)

local function hideCharacterScreen(){
    if (!this.isInCharacterScreen() || this.m.CharacterScreen.isAnimating()) return
    this.hideCharacterScreen()
    return false
}
this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_hideCharacterScreen_1", "i",  hideCharacterScreen, this.MSU.GlobalKeyHandler.States.Tactical)
this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_hideCharacterScreen_2", "c",  hideCharacterScreen, this.MSU.GlobalKeyHandler.States.Tactical)
this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_hideCharacterScreen_3", "escape",  hideCharacterScreen, this.MSU.GlobalKeyHandler.States.Tactical)

this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_toggleMenuScreen", "escape",  function(){
    if (this.isInCharacterScreen()) return
    if (!this.m.MenuStack.hasBacksteps() || this.m.TacticalMenuScreen.isVisible())
    {
        if (this.toggleMenuScreen())
        {
            return false;
        }
    }
}, this.MSU.GlobalKeyHandler.States.Tactical)

this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_toggleStatsOverlays", "alt",  function(){
    if (this.m.MenuStack.hasBacksteps()) return
    this.topbar_options_onToggleStatsOverlaysButtonClicked();
    return false
}, this.MSU.GlobalKeyHandler.States.Tactical)

this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_toggleTreesButton", "t",  function(){
    if (this.m.MenuStack.hasBacksteps()) return
    this.topbar_options_onToggleTreesButtonClicked();
    return false
}, this.MSU.GlobalKeyHandler.States.Tactical)

this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_toggleHighlightBlockedTiles", "b",  function(){
    if (this.m.MenuStack.hasBacksteps()) return
    this.topbar_options_onToggleHighlightBlockedTilesButtonClicked();
    return false
}, this.MSU.GlobalKeyHandler.States.Tactical)

this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_initNextTurn", "enter",  function(){
    if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return
     this.Tactical.TurnSequenceBar.initNextTurn();
    return false
}, this.MSU.GlobalKeyHandler.States.Tactical)

this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_endTurnAll", "r",  function(){
    if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return
    this.Tactical.TurnSequenceBar.onEndTurnAllButtonPressed();
    return false
}, this.MSU.GlobalKeyHandler.States.Tactical)
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

this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_waitTurn_1", "end",  waitTurn, this.MSU.GlobalKeyHandler.States.Tactical)
this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_waitTurn_2", "space",  waitTurn, this.MSU.GlobalKeyHandler.States.Tactical)

this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_focusActiveEntity", "shift",  function(){
    if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return
    this.Tactical.TurnSequenceBar.focusActiveEntity(true);
    return false
}, this.MSU.GlobalKeyHandler.States.Tactical)

local function showCharacterScreen(){
    if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return
    this.showCharacterScreen();
    return false
}

this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_showCharacterScreen_1", "i",  showCharacterScreen, this.MSU.GlobalKeyHandler.States.Tactical)
this.MSU.GlobalKeyHandler.addHandlerFunction("tactical_showCharacterScreen_2", "c",  showCharacterScreen, this.MSU.GlobalKeyHandler.States.Tactical)


