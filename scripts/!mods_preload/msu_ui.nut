this.getroottable().MSU.registerUIFiles <- function()
{
	::mods_registerCSS("msu_css.css");
	::mods_registerJS("msu_ui_screen.js");
	::mods_registerJS("msu_mod_settings_screen.js");

	::mods_hookNewObjectOnce("states/main_menu_state", function(o)
	{
		local main_menu_screen_onScreenShown = o.main_menu_screen_onScreenShown;
		o.main_menu_module_onCreditsPressed = function()
		{
			if (!this.MSU.SettingsScreen.isConnected())
			{
				this.MSU.SettingsScreen.connect();
				this.MSU.SettingsScreen.linkMenuStack(this.m.MenuStack);
			}
			this.m.MainMenuScreen.hide();
			this.m.MenuStack.push(function ()
			{
				this.MSU.SettingsScreen.hide();
				this.m.MainMenuScreen.show(false);
			}, function ()
			{
				return !this.MSU.SettingsScreen.isAnimating()
			});
			this.MSU.SettingsScreen.show(true);
		}
	});

	::mods_hookNewObject("ui/screens/world/modules/topbar/world_screen_topbar_options_module", function(o)
	{
		local onBrothersButtonPressed = o.onBrothersButtonPressed;
		o.onBrothersButtonPressed = function()
		{
			this.World.State.m.WorldScreen.hide();
			this.MSU.SettingsScreen.connect();
			this.MSU.SettingsScreen.show(true);
			this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
		}
	});

}
