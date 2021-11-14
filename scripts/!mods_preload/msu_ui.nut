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
			this.MSU.SettingsScreen.connect();
			this.MSU.SettingsScreen.show(true);
		}
	});

}
