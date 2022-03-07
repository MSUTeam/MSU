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

	local menu_onKeyInput = o.onKeyInput;
	o.onKeyInput = function( _key )
	{
	    if (_key.getState() != 0)
	    { 
	        return menu_onKeyInput(_key);
	    }
	    local customHandling = this.MSU.GlobalKeyHandler.ProcessInput(_key, this, this.MSU.GlobalKeyHandler.States.MainMenu);
	    if (customHandling == false)
	    {
	        return false;
	    }
	    return menu_onKeyInput(_key);
	}

	//menu mouse input  somehow doesn't register any ID but 6 (movement)
	local menu_mouseInput = o.onMouseInput;
	o.onMouseInput = function( _mouse )
	{
	    if (_mouse.getState() != 1 || _mouse.getID() == 6)
	    { 
	        return menu_mouseInput(_mouse);
	    }
	    local customHandling = this.MSU.GlobalKeyHandler.ProcessInput(_mouse, this, this.MSU.GlobalKeyHandler.States.MainMenu, this.MSU.GlobalKeyHandler.InputType.Mouse);
	    if (customHandling == false)
	    {
	        return false;
	    }
	    return menu_mouseInput(_mouse);
	}
});
