::MSU.Vanilla.Keybinds.addSQKeybind("character_closeCharacterScreen", "c/i/escape", ::MSU.Key.State.World | ::MSU.Key.State.Tactical, function()
{
	if (!this.isInCharacterScreen()) return;
	if (::MSU.isKindOf(this, "tactical_state"))
	{
		this.hideCharacterScreen();
	}
	else
	{
		this.toggleCharacterScreen();
	}
	return true;
}, "Close Character Screen");

::MSU.Vanilla.Keybinds.addSQKeybind("character_openCharacterScreen", "c/i", ::MSU.Key.State.World | ::MSU.Key.State.Tactical, function()
{
	if (::MSU.isKindOf(this, "tactical_state"))
	{
		if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return;
		this.showCharacterScreen();
		return true;
	}
	else
	{
		if (!this.m.MenuStack.hasBacksteps() || this.m.CharacterScreen.isVisible() || this.m.WorldTownScreen.isVisible() && !this.m.EventScreen.isVisible())
		{
			if (!this.m.EventScreen.isVisible() && !this.m.EventScreen.isAnimating())
			{
				this.toggleCharacterScreen();
				return true;
			}
		}
	}
}, "Open Character Screen");

::MSU.Vanilla.Keybinds.addSQKeybind("character_switchToPreviousBrother", "left/a", ::MSU.Key.State.World | ::MSU.Key.State.Tactical, function()
{
	if (!this.isInCharacterScreen()) return;
	this.m.CharacterScreen.switchToPreviousBrother();
	return true;
}, "Switch to Previous Brother");

::MSU.Vanilla.Keybinds.addSQKeybind("character_switchToNextBrother", "right/d/tab", ::MSU.Key.State.World | ::MSU.Key.State.Tactical, function()
{
	if (!this.isInCharacterScreen()) return;
	this.m.CharacterScreen.switchToNextBrother();
	return true;
}, "Switch to Next Brother");

local function isCampfireScreen()
{
	return this.m.CampfireScreen != null && this.m.CampfireScreen.isVisible();
}

::MSU.Vanilla.Keybinds.addSQKeybind("toggleMenuScreen", "escape", ::MSU.Key.State.World | ::MSU.Key.State.Tactical, function()
{
	if (::MSU.isKindOf(this, "world_state"))
	{
		if (isCampfireScreen.call(this)) return;
		if (!this.m.WorldMenuScreen.isAnimating() && this.toggleMenuScreen())
		{
			return true;
		}
	}
	else
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

::MSU.Vanilla.Keybinds.addDivider("world_divider");
::MSU.Vanilla.Keybinds.addTitle("world_title", "World Keybinds");

::MSU.Vanilla.Keybinds.addSQKeybind("world_closeCampfireScreen", "p/escape", ::MSU.Key.State.World, function()
{
	if (!isCampfireScreen.call(this)) return;
	this.m.CampfireScreen.onModuleClosed();
	return true;
}, "Close Campfire Screen");

::MSU.Vanilla.Keybinds.addSQKeybind("world_toggleRelationScreen", "r", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps() && !this.m.EventScreen.isVisible() && !this.m.EventScreen.isAnimating())
	{
		this.topbar_options_module_onRelationsButtonClicked();
		return true;
	}
	else if (this.m.RelationsScreen.isVisible())
	{
		this.m.RelationsScreen.onClose();
		return true;
	}
}, "Toggle Relations Screen");

::MSU.Vanilla.Keybinds.addSQKeybind("world_toggleObituarysScreen", "o", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps() && !this.m.EventScreen.isVisible() && !this.m.EventScreen.isAnimating())
	{
		this.topbar_options_module_onObituaryButtonClicked();
		return true;
	}
	else if (this.m.ObituaryScreen.isVisible())
	{
		this.m.ObituaryScreen.onClose();
		return true;
	}
}, "Toggle Obituary Screen");

::MSU.Vanilla.Keybinds.addSQKeybind("world_toggleCamping", "t", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps())
	{
		if (this.isCampingAllowed())
		{
			this.onCamp();
			return true;
		}
	}
}, "Toggle Camping");


::MSU.Vanilla.Keybinds.addSQKeybind("world_toggleRetinueButton", "p", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps() && !this.m.EventScreen.isVisible() && !this.m.EventScreen.isAnimating())
	{
		this.topbar_options_module_onPerksButtonClicked();
		return true;
	}
}, "Toggle Retinue SCreen");

::MSU.Vanilla.Keybinds.addSQKeybind("world_pause", "0/pause", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps())
	{
		this.setPause(!this.isPaused());
		return true;
	}
}, "Pause World");

::MSU.Vanilla.Keybinds.addSQKeybind("world_speedNormal", "1", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps())
	{
		this.setNormalTime();
		return true;
	}
}, "Normal World Speed (1x)");

::MSU.Vanilla.Keybinds.addSQKeybind("world_speedFast", "2", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps())
	{
		this.setFastTime();
		return true;
	}
}, "Fast World Speed (2x)");

::MSU.Vanilla.Keybinds.addSQKeybind("world_trackingButton", "f", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps())
	{
		this.m.WorldScreen.getTopbarOptionsModule().onTrackingButtonPressed();
		return true;
	}
}, "Toggle Tracks");

::MSU.Vanilla.Keybinds.addSQKeybind("world_cameraLockButton", "x", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps())
	{
		this.m.WorldScreen.getTopbarOptionsModule().onCameraLockButtonPressed();
		return true;
	}
}, "Lock Camera on Party");

::MSU.Vanilla.Keybinds.addSQKeybind("world_quicksave", "f5", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps() && !::World.Assets.isIronman())
	{
		this.saveCampaign("quicksave");
		return true;
	}
}, "Quicksave")

::MSU.Vanilla.Keybinds.addSQKeybind("world_quickload", "f9", ::MSU.Key.State.World, function()
{
	if (!this.m.MenuStack.hasBacksteps() && !::World.Assets.isIronman() && ::World.canLoad("quicksave"))
	{
		this.loadCampaign("quicksave");
		return true;
	}
}, "Quickload")

::MSU.Vanilla.Keybinds.addSQKeybind("world_event_1", "1", ::MSU.Key.State.World, function()
{
	if (!this.m.EventScreen.isVisible() || this.m.EventScreen.isAnimating())
	{
		return;
	}

	this.m.EventScreen.onButtonPressed(0);
	return true;
}, "Select Event Option 1", null, "Click the first button from the top in a world event");

::MSU.Vanilla.Keybinds.addSQKeybind("world_event_2", "2", ::MSU.Key.State.World, function()
{
	if (!this.m.EventScreen.isVisible() || this.m.EventScreen.isAnimating())
	{
		return;
	}

	this.m.EventScreen.onButtonPressed(1);
	return true;
}, "Select Event Option 2", null, "Click the second button from the top in a world event");

::MSU.Vanilla.Keybinds.addSQKeybind("world_event_3", "3", ::MSU.Key.State.World, function()
{
	if (!this.m.EventScreen.isVisible() || this.m.EventScreen.isAnimating())
	{
		return;
	}

	this.m.EventScreen.onButtonPressed(2);
	return true;
}, "Select Event Option 3", null, "Click the third button from the top in a world event");

::MSU.Vanilla.Keybinds.addSQKeybind("world_event_4", "4", ::MSU.Key.State.World, function()
{
	if (!this.m.EventScreen.isVisible() || this.m.EventScreen.isAnimating())
	{
		return;
	}

	this.m.EventScreen.onButtonPressed(3);
	return true;
}, "Select Event Option 4", null, "Click the fourth button from the top in a world event");

::MSU.Vanilla.Keybinds.addSQKeybind("world_toggle_forceattack", "ctrl", ::MSU.Key.State.World, function()
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
			return true;
		}
	}
}, "Toggle Forced Attack", ::MSU.Key.KeyState.Release | ::MSU.Key.KeyState.Press);

// World Continuous, doesn't work cuz we handle keybinds differently from vanilla ):

// ::MSU.Vanilla.Keybinds.addSQKeybind("world_moveCamera_left", "left/a/q", ::MSU.Key.State.World, function()
// {
// 	if (::Settings.getTempGameplaySettings().CameraLocked)
// 	{
// 		this.m.WorldScreen.getTopbarOptionsModule().onCameraLockButtonPressed();
// 	}

// 	::World.getCamera().move(-1500.0 * ::Time.getDelta() * ::Math.maxf(1.0, ::World.getCamera().Zoom * 0.66), 0);
// 	return true;
// }, "Move Camera Up", null, ::MSU.Key.KeyState.Continuous | ::MSU.Key.KeyState.Press);

// ::MSU.Vanilla.Keybinds.addSQKeybind("world_moveCamera_right", "right/d", ::MSU.Key.State.World, function()
// {
// 	if (::Settings.getTempGameplaySettings().CameraLocked)
// 	{
// 		this.m.WorldScreen.getTopbarOptionsModule().onCameraLockButtonPressed();
// 	}

// 	::World.getCamera().move(1500.0 * ::Time.getDelta() * ::Math.maxf(1.0, ::World.getCamera().Zoom * 0.66), 0);
// 	return true;
// }, "Move Camera Right", null, ::MSU.Key.KeyState.Continuous | ::MSU.Key.KeyState.Press);

//-------------------------------------------TACTICAL ONLY---------------------------------------------------------------------------------

::MSU.Vanilla.Keybinds.addDivider("tactical_divider");
::MSU.Vanilla.Keybinds.addTitle("tactical_title", "Combat Keybinds");

::MSU.Vanilla.Keybinds.addSQKeybind("tactical_hideCharacterScreen", "enter", ::MSU.Key.State.Tactical, function()
{
	if (!this.isInCharacterScreen()) return;
	if (this.m.CharacterScreen.isInBattlePreparationMode() == true)
	{
		this.hideCharacterScreen();
		return true;
	}
}, "Close Character Screen");

::MSU.Vanilla.Keybinds.addSQKeybind("tactical_toggleStatsOverlays", "alt", ::MSU.Key.State.Tactical, function()
{
	if (this.m.MenuStack.hasBacksteps()) return;
	this.topbar_options_onToggleStatsOverlaysButtonClicked();
	return true;
}, "Toggle Stats Overlay");

::MSU.Vanilla.Keybinds.addSQKeybind("tactical_toggleTreesButton", "t", ::MSU.Key.State.Tactical, function()
{
	if (this.m.MenuStack.hasBacksteps()) return;
	this.topbar_options_onToggleTreesButtonClicked();
	return true;
}, "Toggle Trees");

::MSU.Vanilla.Keybinds.addSQKeybind("tactical_toggleHighlightBlockedTiles", "b", ::MSU.Key.State.Tactical, function()
{
	if (this.m.MenuStack.hasBacksteps()) return;
	this.topbar_options_onToggleHighlightBlockedTilesButtonClicked();
	return true;
}, "Toggle Highlighting Blocked Tiles");

::MSU.Vanilla.Keybinds.addSQKeybind("tactical_initNextTurn", "enter", ::MSU.Key.State.Tactical, function()
{
	if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return;
	 ::Tactical.TurnSequenceBar.initNextTurn();
	return true;
}, "End Turn for Character");

::MSU.Vanilla.Keybinds.addSQKeybind("tactical_endTurnAll", "r", ::MSU.Key.State.Tactical, function()
{
	if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return;
	::Tactical.TurnSequenceBar.onEndTurnAllButtonPressed();
	return true;
}, "End Turn for All Characters");

::MSU.Vanilla.Keybinds.addSQKeybind("tactical_waitTurn", "end/space", ::MSU.Key.State.Tactical, function()
{
	if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return;
	if (::Tactical.TurnSequenceBar.getActiveEntity() != null && ::Tactical.TurnSequenceBar.getActiveEntity().isPlayerControlled())
	{
		local wasAbleToWait = ::Tactical.TurnSequenceBar.entityWaitTurn(::Tactical.TurnSequenceBar.getActiveEntity());

		if (!wasAbleToWait)
		{
			::Tactical.TurnSequenceBar.initNextTurn();
		}
		return true;
	}
}, "Wait Character Turn");

::MSU.Vanilla.Keybinds.addSQKeybind("tactical_focusActiveEntity", "shift", ::MSU.Key.State.Tactical, function()
{
	if (this.m.MenuStack.hasBacksteps() || this.isInputLocked() || this.isInCharacterScreen()) return;
	::Tactical.TurnSequenceBar.focusActiveEntity(true);
	return true;
}, "Focus on Active Character");


// ::MSU.System.Keybinds.registerMod(::MSU.ID)
// local jskeybind = ::MSU.Class.KeybindJS(::MSU.ID, "testkb", "ctrl+s");
// ::MSU.System.Keybinds.add(jskeybind);
