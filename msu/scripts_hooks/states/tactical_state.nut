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
		this.MSU.Systems.ModSettings.updateSettings(_data);
		this.m.MenuStack.pop();
	}
});