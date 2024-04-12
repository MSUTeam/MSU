::MSU.MH.hook("scripts/states/main_menu_state", function(q) {
	q.m.ModSettingsShown <- false;
	q.m.TempSettings <- null;

	q.onInit = @(__original) function()
	{
		__original();
		local mainMenuModule = this.m.MainMenuScreen.getMainMenuModule();
		mainMenuModule.setOnModOptionsPressedListener(this.main_menu_module_onModOptionsPressed.bindenv(this));
	}

	q.main_menu_module_onModOptionsPressed <- function()
	{
		::MSU.SettingsScreen.setOnCancelPressedListener(this.msu_settings_screen_onCancelPressed.bindenv(this)); // Need to bind these every time because it's a new screen and not a module (which tbh was probs a mistake).
		::MSU.SettingsScreen.setOnSavePressedListener(this.msu_settings_screen_onSavepressed.bindenv(this));
		this.m.MainMenuScreen.hideMainMenuModule();
		::MSU.SettingsScreen.show(::MSU.SettingsFlags.Main);
		this.m.MenuStack.push(function ()
		{
			::MSU.SettingsScreen.hide();
			this.m.MainMenuScreen.showMainMenuModule();
		}, function ()
		{
			return !::MSU.SettingsScreen.isAnimating();
		});
	}

	q.campaign_menu_module_onStartPressed = @(__original) function( _settings )
	{
		this.m.TempSettings = _settings;
		if (this.m.ModSettingsShown || !::MSU.System.ModSettings.isVisibleWithFlags(::MSU.SettingsFlags.NewCampaign))
		{
			__original(_settings);
		}
		else
		{
			this.m.ModSettingsShown = true;
			::MSU.SettingsScreen.setOnCancelPressedListener(this.msu_settings_screen_onCancelPressed.bindenv(this));
			::MSU.SettingsScreen.setOnSavePressedListener(this.msu_settings_screen_onSavepressed.bindenv(this));
			this.m.MainMenuScreen.hideNewCampaignModule();
			::MSU.SettingsScreen.show(::MSU.SettingsFlags.NewCampaign);
			this.m.MenuStack.push(function ()
			{
				::MSU.SettingsScreen.hide();
				this.m.MainMenuScreen.showNewCampaignModule();
			}, function ()
			{
				return !::MSU.SettingsScreen.isAnimating();
			})
		}
	}

	q.msu_settings_screen_onCancelPressed <- function()
	{
		this.m.ModSettingsShown = false;
		this.m.MenuStack.pop();
	}

	q.msu_settings_screen_onSavepressed <- function( _data )
	{
		::MSU.System.ModSettings.updateSettingsFromJS(_data);
		this.m.MenuStack.pop();
		if (this.m.ModSettingsShown)
		{
			campaign_menu_module_onStartPressed(this.m.TempSettings);
			this.m.TempSettings = null;
			this.m.ModSettingsShown = false;
		}
	}

	q.onKeyInput = @(__original) function( _key )
	{
		if (!::MSU.Key.isKnownKey(_key))
		{
			return __original(_key);
		}
		if (::MSU.System.Keybinds.onKeyInput(_key, this, ::MSU.Key.State.MainMenu) || ::MSU.Mod.ModSettings.getSetting("SuppressBaseKeybinds").getValue())
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
		if (::MSU.System.Keybinds.onMouseInput(_mouse, this, ::MSU.Key.State.MainMenu))
		{
			return false;
		}
		return __original(_mouse);
	}
});
