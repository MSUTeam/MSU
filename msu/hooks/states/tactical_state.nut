::MSU.HooksMod.hook("scripts/states/tactical_state", function(q) {
	q.executeEntityTravel = @(__original) function( _activeEntity, _mouseEvent )
	{
		_activeEntity.getSkills().m.IsPreviewing = false;
		return __original(_activeEntity, _mouseEvent);
	}

	local executeEntitySkill = o.executeEntitySkill;
	q.executeEntitySkill = @(__original) function( _activeEntity, _targetTile )
	{
		_activeEntity.getSkills().m.IsPreviewing = false;
		return __original(_activeEntity, _targetTile);
	}

	q.onInitUI = @(__original) function()
	{
		__original();
		local mainMenuModule = this.m.TacticalMenuScreen.getMainMenuModule();
		mainMenuModule.setOnModOptionsPressedListener(this.main_menu_module_onModOptionsPressed.bindenv(this));
	}

	q.main_menu_module_onModOptionsPressed <- function()
	{
		::MSU.SettingsScreen.setOnCancelPressedListener(this.msu_settings_screen_onCancelPressed.bindenv(this));
		::MSU.SettingsScreen.setOnSavePressedListener(this.msu_settings_screen_onSavepressed.bindenv(this));
		this.m.TacticalMenuScreen.hide();
		::MSU.SettingsScreen.show(::MSU.SettingsFlags.Tactical);
		this.m.MenuStack.push(function ()
		{
			::MSU.SettingsScreen.hide();
			local allowRetreat = this.m.StrategicProperties == null || !this.m.StrategicProperties.IsFleeingProhibited;
			local allowQuit = !this.isScenarioMode();
			this.m.TacticalMenuScreen.show(allowRetreat, allowQuit, !this.isScenarioMode() && ::World.Assets.isIronman() ? "Quit & Retire" : "Quit");
		}, function ()
		{
			return !::MSU.SettingsScreen.isAnimating();
		});
	}

	q.msu_settings_screen_onCancelPressed <- function ()
	{
		this.m.MenuStack.pop();
	}

	q.msu_settings_screen_onSavepressed <- function( _data )
	{
		::MSU.System.ModSettings.updateSettingsFromJS(_data);
		this.m.MenuStack.pop();
	}

	q.onKeyInput = @(__original) function( _key )
	{
		if (!::MSU.Key.isKnownKey(_key))
		{
			return __original(_key);
		}
		if (::MSU.System.Keybinds.onKeyInput(_key, this, ::MSU.Key.State.Tactical) || ::MSU.Mod.ModSettings.getSetting("SuppressBaseKeybinds").getValue())
		{
			return false;
		}
		return __original(_key);
	}

	q.onMouseInput = @(__original) function( _mouse )
	{
		if (!::MSU.Key.isKnownMouse(_mouse))
		{
			return __original(_mouse);
		}
		if (::MSU.System.Keybinds.onMouseInput(_mouse, this, ::MSU.Key.State.Tactical))
		{
			return false;
		}
		return __original(_mouse);
	}
});
