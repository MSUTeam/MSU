::mods_hookNewObjectOnce("states/main_menu_state", function(o) {
	o.m.ModSettingsShown <- false;
	o.m.TempSettings <- null;

	local show = o.show; //Not the best hook but can't hook onInit directly
	o.show = function()
	{
		local mainMenuModule = this.m.MainMenuScreen.getMainMenuModule();
		mainMenuModule.setOnModOptionsPressedListener(this.main_menu_module_onModOptionsPressed.bindenv(this));
		show();
	}

	o.main_menu_module_onModOptionsPressed <- function()
	{
		this.MSU.SettingsScreen.setOnCancelPressedListener(this.msu_settings_screen_onCancelPressed.bindenv(this)); // Need to bind these every time because it's a new screen and not a module (which tbh was probs a mistake).
		this.MSU.SettingsScreen.setOnSavePressedListener(this.msu_settings_screen_onSavepressed.bindenv(this));
		this.m.MainMenuScreen.hideMainMenuModule();
		this.MSU.SettingsScreen.show(this.MSU.SettingsFlags.Main);
		this.m.MenuStack.push(function ()
		{
			this.MSU.SettingsScreen.hide();
			this.m.MainMenuScreen.showMainMenuModule();
		}, function ()
		{
			return !this.MSU.SettingsScreen.isAnimating();
		});
	}

	local campaign_menu_module_onStartPressed = o.campaign_menu_module_onStartPressed;
	o.campaign_menu_module_onStartPressed = function( _settings )
	{
		this.m.TempSettings = _settings;
		if (this.m.ModSettingsShown)
		{
			campaign_menu_module_onStartPressed(_settings);
		}
		else
		{
			this.m.ModSettingsShown = true;
			this.MSU.SettingsScreen.setOnCancelPressedListener(this.msu_settings_screen_onCancelPressed.bindenv(this));
			this.MSU.SettingsScreen.setOnSavePressedListener(this.msu_settings_screen_onSavepressed.bindenv(this));
			this.m.MainMenuScreen.hideNewCampaignModule();
			this.MSU.SettingsScreen.show(this.MSU.SettingsFlags.NewCampaign);
			this.m.MenuStack.push(function ()
			{
				this.MSU.SettingsScreen.hide();
				this.m.MainMenuScreen.showNewCampaignModule();
			}, function ()
			{
				return !this.MSU.SettingsScreen.isAnimating();
			})
		}
	}

	o.msu_settings_screen_onCancelPressed <- function ()
	{
		this.m.ModSettingsShown = false;
		this.m.MenuStack.pop();
	}

	o.msu_settings_screen_onSavepressed <- function( _data )
	{
		this.MSU.System.ModSettings.updateSettings(_data);
		this.m.MenuStack.pop();
		if (this.m.ModSettingsShown)
		{
			campaign_menu_module_onStartPressed(this.m.TempSettings);
			this.m.TempSettings = null;
			this.m.ModSettingsShown = false;
		}
	}

	local onKeyInput = o.onKeyInput;
	o.onKeyInput = function( _key )
	{
		if (!::MSU.System.Keybinds.updatePressedKey(_key)) // if was pressed down before, just return the normal onKeyInput
		{
			return onKeyInput(_key);
		}
		if (!::MSU.System.Keybinds.onKeyInput(_key, this, ::MSU.Key.State.MainMenu))
		{
			return false;
		}
		return onKeyInput(_key);
	}

	local onMouseInput = o.onMouseInput;
	o.onMouseInput = function( _mouse )
	{
		if (_mouse.getState() != 1 || _mouse.getID() == 6)
		{
			return onMouseInput(_mouse);
		}
		if (!::MSU.System.Keybinds.onMouseInput(_mouse, this, ::MSU.Key.State.MainMenu))
		{
			return false;
		}
		return onMouseInput(_mouse);
	}
});
