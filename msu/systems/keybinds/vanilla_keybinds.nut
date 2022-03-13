::MSU.System.Keybinds.registerMod(::MSU.VanillaID);
function addKeybind( _id, _keyCombinations, _state, _function, _name, _description = "", _keyState = null )
{
	local keybind = ::MSU.Class.KeybindSQ(::MSU.VanillaID, _id, _keyCombinations, _state, _function, _name, _keyState);
	keybind.setDescription(_description);
	::MSU.System.Keybinds.add(keybind);

}

addKeybind("character_closeCharacterScreen", "c/i/escape", ::MSU.Key.State.World | ::MSU.Key.State.Tactical, function()
{
	if (!this.isInCharacterScreen()) return;
	this.toggleCharacterScreen();
	return false;
}, "Close Character Screen");

addKeybind("character_openCharacterScreen", "c/i", ::MSU.Key.State.World | ::MSU.Key.State.Tactical, function()
{
	if (::mods_isClass(this, "tactical_state"))
	{
		if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return;
		this.showCharacterScreen();
		return false;
	}
	else if (::mods_isClass(this, "world_state"))
	{
		if (!this.m.MenuStack.hasBacksteps() || this.m.CharacterScreen.isVisible() || this.m.WorldTownScreen.isVisible() && !this.m.EventScreen.isVisible())
		{
			if (!this.m.EventScreen.isVisible() && !this.m.EventScreen.isAnimating())
			{
				this.toggleCharacterScreen();
				return false;
			}
		}
	}
}, "Open Character Screen");

addKeybind("character_switchToPreviousBrother", "left/a", ::MSU.Key.State.World | ::MSU.Key.State.Tactical, function()
{
	if (!this.isInCharacterScreen()) return;
	this.m.CharacterScreen.switchToPreviousBrother();
	return false;
}, "Switch to Previous Brother");

addKeybind("character_switchToNextBrother", "right/d/tab", ::MSU.Key.State.World | ::MSU.Key.State.Tactical, function()
{
	if (!this.isInCharacterScreen()) return;
	this.m.CharacterScreen.switchToNextBrother();
	return false;
}, "Switch to Next Brother");

local function isCampfireScreen(){
	return this.m.CampfireScreen != null && this.m.CampfireScreen.isVisible();
}

addKeybind("world_toggleMenuScreen", "escape", ::MSU.Key.State.World, function()
{
	if (::mods_isClass(this, "world_state"))
	{
		if (isCampfireScreen.call(this)) return;
		if (this.toggleMenuScreen())
		{
			return false;
		}
	}
	else if (::mods_isClass(this, "tactical_state"))
	{
		if (!this.m.MenuStack.hasBacksteps() || this.m.TacticalMenuScreen.isVisible())
		{
			if (this.toggleMenuScreen())
			{
				return true;
			}
		}
	}
}, "Toggle Menu Screen");


//-------------------------------------------WORLD ONLY---------------------------------------------------------------------------------

::MSU.System.Keybinds.addKeybindDivider(::MSU.VanillaID, "world", "World Keybinds");

addKeybind("world_closeCampfireScreen", "p/escape", ::MSU.Key.State.World, function()
{
	if (!isCampfireScreen.call(this)) return;
	this.m.CampfireScreen.onModuleClosed();
	return false;
}, "Close Campfire Screen");

addKeybind("world_toggleRelationScreen", "r", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps() && !this.m.EventScreen.isVisible() && !this.m.EventScreen.isAnimating())
	{
		this.topbar_options_module_onRelationsButtonClicked();
		return false;
	}
	else if (this.m.RelationsScreen.isVisible())
	{
		this.m.RelationsScreen.onClose();
		return false;
	}
}, "Toggle Relations Screen");

addKeybind("world_toggleObituarysScreen", "o", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps() && !this.m.EventScreen.isVisible() && !this.m.EventScreen.isAnimating())
	{
		this.topbar_options_module_onObituaryButtonClicked();
		return false;
	}
	else if (this.m.ObituaryScreen.isVisible())
	{
		this.m.ObituaryScreen.onClose();
		return false;
	}
}, "Toggle Obituary Screen");

addKeybind("world_toggleCamping", "t", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps())
	{
		if (this.isCampingAllowed())
		{
			this.onCamp();
			return false;
		}
	}
}, "Toggle Camping");


addKeybind("world_toggleRetinueButton", "p", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps() && !this.m.EventScreen.isVisible() && !this.m.EventScreen.isAnimating())
	{
		this.topbar_options_module_onPerksButtonClicked();
		return false;
	}
}, "Toggle Retinue SCreen");

addKeybind("world_pause", "0/pause", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps())
	{
		this.setPause(!this.isPaused());
		return false;
	}
}, "Pause World");

addKeybind("world_speedNormal", "1", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps())
	{
		this.setNormalTime();
		return false;
	}
}, "Normal World Speed (1x)");

addKeybind("world_speedFast", "2", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps())
	{
		this.setFastTime();
		return false;
	}
}, "Fast World Speed (2x)");

addKeybind("world_trackingButton", "f", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps())
	{
		this.m.WorldScreen.getTopbarOptionsModule().onTrackingButtonPressed();
		return false;
	}
}, "Toggle Tracks");

addKeybind("world_cameraLockButton", "x", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps())
	{
		this.m.WorldScreen.getTopbarOptionsModule().onCameraLockButtonPressed();
		return false;
	}
}, "Lock Camera on Party");

addKeybind("world_quicksave", "f5", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps() && !this.World.Assets.isIronman())
	{
		this.saveCampaign("quicksave");
		return false;
	}
}, "Quicksave")

addKeybind("world_quickload", "f9", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps() && !this.World.Assets.isIronman() && this.World.canLoad("quicksave"))
	{
		this.loadCampaign("quicksave");
		return false;
	}
}, "Quickload")

addKeybind("world_event_1", "1", ::MSU.Key.State.World, function()
{
	if (!this.m.EventScreen.isVisible() || this.m.EventScreen.isAnimating())
	{
		return
	}

	this.m.EventScreen.onButtonPressed(0);
	return false;
}, "Select Event Option 1", "Click the first button from the top in a world event");

addKeybind("world_event_2", "2", ::MSU.Key.State.World, function()
{
	if (!this.m.EventScreen.isVisible() || this.m.EventScreen.isAnimating())
	{
		return
	}

	this.m.EventScreen.onButtonPressed(1);
	return false;
}, "Select Event Option 2", "Click the second button from the top in a world event");

addKeybind("world_event_3", "3", ::MSU.Key.State.World, function()
{
	if (!this.m.EventScreen.isVisible() || this.m.EventScreen.isAnimating())
	{
		return
	}

	this.m.EventScreen.onButtonPressed(2);
	return false;
}, "Select Event Option 3", "Click the third button from the top in a world event");

addKeybind("world_event_4", "4", ::MSU.Key.State.World, function()
{
	if (!this.m.EventScreen.isVisible() || this.m.EventScreen.isAnimating())
	{
		return
	}

	this.m.EventScreen.onButtonPressed(3);
	return false;
}, "Select Event Option 4", "Click the fourth button from the top in a world event");

addKeybind("world_toggle_forceattack", "ctrl", ::MSU.Key.State.World, function()
{
	if (this.m.IsForcingAttack)
	{
		this.m.IsForcingAttack = false;
	}
	else
	{
		if (!this.m.MenuStack.hasBacksteps())
		{
			this.m.IsForcingAttack = true;
			return false;
		}
	}
}, "Toggle Forced Attack", null, ::MSU.Key.KeyState.All);

//-------------------------------------------TACTICAL ONLY---------------------------------------------------------------------------------

::MSU.System.Keybinds.addKeybindDivider(::MSU.VanillaID, "tactical", "Combat Keybinds")

addKeybind("tactical_hideCharacterScreen", "enter", ::MSU.Key.State.Tactical ,function()
{
	if (!this.isInCharacterScreen()) return;
	if (this.m.CharacterScreen.isInBattlePreparationMode() == true)
	{
		this.hideCharacterScreen();
		return false;
	}
}, "Close Character Screen");

addKeybind("tactical_toggleStatsOverlays", "alt", ::MSU.Key.State.Tactical, function()
{
	if (this.m.MenuStack.hasBacksteps()) return;
	this.topbar_options_onToggleStatsOverlaysButtonClicked();
	return false;
}, "Toggle Stats Overlay");

addKeybind("tactical_toggleTreesButton", "t", ::MSU.Key.State.Tactical, function()
{
	if (this.m.MenuStack.hasBacksteps()) return;
	this.topbar_options_onToggleTreesButtonClicked();
	return false;
}, "Toggle Trees");

addKeybind("tactical_toggleHighlightBlockedTiles", "b", ::MSU.Key.State.Tactical, function()
{
	if (this.m.MenuStack.hasBacksteps()) return;
	this.topbar_options_onToggleHighlightBlockedTilesButtonClicked();
	return false;
}, "Toggle Highlighting Blocked Tiles");

addKeybind("tactical_initNextTurn", "enter", ::MSU.Key.State.Tactical, function()
{
	if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return;
	 this.Tactical.TurnSequenceBar.initNextTurn();
	return false;
}, "End Turn for Character");

addKeybind("tactical_endTurnAll", "r", ::MSU.Key.State.Tactical, function()
{
	if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return;
	this.Tactical.TurnSequenceBar.onEndTurnAllButtonPressed();
	return false;
}, "End Turn for All Characters");

addKeybind("tactical_waitTurn", "end/space", ::MSU.Key.State.Tactical, function()
{
	if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return;
	if (this.Tactical.TurnSequenceBar.getActiveEntity() != null && this.Tactical.TurnSequenceBar.getActiveEntity().isPlayerControlled())
	{
		local wasAbleToWait = this.Tactical.TurnSequenceBar.entityWaitTurn(this.Tactical.TurnSequenceBar.getActiveEntity());

		if (!wasAbleToWait)
		{
			this.Tactical.TurnSequenceBar.initNextTurn();
		}
		return false;
	}
}, "Wait Character Turn");

addKeybind("tactical_focusActiveEntity", "shift", ::MSU.Key.State.Tactical, function()
{
	if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return;
	this.Tactical.TurnSequenceBar.focusActiveEntity(true);
	return false;
}, "Focus on Active Character");
