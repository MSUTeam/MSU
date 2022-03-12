::mods_hookExactClass("states/tactical_state", function(o) {
	local onInitUI = o.onInitUI;
	o.onInitUI = function()
	{
		onInitUI();
		local mainMenuModule = this.m.TacticalMenuScreen.getMainMenuModule();
		mainMenuModule.setOnModOptionsPressedListener(this.main_menu_module_onModOptionsPressed.bindenv(this));
	}

	o.main_menu_module_onModOptionsPressed <- function()
	{
		this.MSU.SettingsScreen.setOnCancelPressedListener(this.msu_settings_screen_onCancelPressed.bindenv(this));
		this.MSU.SettingsScreen.setOnSavePressedListener(this.msu_settings_screen_onSavepressed.bindenv(this));
		this.m.TacticalMenuScreen.hide();
		this.MSU.SettingsScreen.show(this.MSU.SettingsFlags.Tactical);
		this.m.MenuStack.push(function ()
		{
			this.MSU.SettingsScreen.hide();
			local allowRetreat = this.m.StrategicProperties == null || !this.m.StrategicProperties.IsFleeingProhibited;
			local allowQuit = !this.isScenarioMode();
			this.m.TacticalMenuScreen.show(allowRetreat, allowQuit, !this.isScenarioMode() && this.World.Assets.isIronman() ? "Quit & Retire" : "Quit");
		}, function ()
		{
			return !this.MSU.SettingsScreen.isAnimating();
		});
	}

	o.msu_settings_screen_onCancelPressed <- function ()
	{
		this.m.MenuStack.pop();
	}

	o.msu_settings_screen_onSavepressed <- function( _data )
	{
		this.MSU.System.ModSettings.updateSettings(_data);
		this.m.MenuStack.pop();
	}


    local tactical_keyFunc = o.onKeyInput;
    o.onKeyInput = function( _key )
    {
    	if (!this.MSU.GlobalKeyHandler.processPressedKeys(_key)) // if was pressed down before, just return the normal onKeyInput
    	{
    	    return tactical_keyFunc(_key);
    	}
        local customHandling = this.MSU.GlobalKeyHandler.processInput(_key, this, this.MSU.GlobalKeyHandler.States.Tactical);
        if (customHandling == false)
        {
            return false;
        }
        return tactical_keyFunc(_key);
    }
    local tactical_mouseInput = o.onMouseInput;
    o.onMouseInput = function( _mouse )
    {
        if (_mouse.getState() != 1 || _mouse.getID() == 6)
        {
            return tactical_mouseInput(_mouse);
        }
        local customHandling = this.MSU.GlobalKeyHandler.processInput(_mouse, this, this.MSU.GlobalKeyHandler.States.Tactical, this.MSU.GlobalKeyHandler.InputType.Mouse);
        if (customHandling == false)
        {
            return false;
        }
        return tactical_mouseInput(_mouse);
    }
});
