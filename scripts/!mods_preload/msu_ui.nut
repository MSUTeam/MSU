this.getroottable().MSU.registerUIFiles <- function()
{
	::mods_registerCSS("msu_css.css");
	::mods_registerJS("msu_ui_screen.js");
	::mods_registerJS("msu_mod_settings_screen.js");
	::mods_registerJS("msu_mod_screens.js");

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
			this.MSU.SettingsScreen.show(true);
			this.m.MainMenuScreen.hide();
			this.m.MenuStack.push(function ()
			{
				this.m.MainMenuScreen.show(false);
				this.MSU.SettingsScreen.hide();
			}, function ()
			{
				return !this.MSU.SettingsScreen.isAnimating()
			});
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

	::mods_hookExactClass("ui/screens/menu/modules/main_menu_module", function(o)
	{
		o.m.OnModOptionsPressedListener <- null;

		function setOnModOptionsPressedListener( _listener )
		{
			this.m.OnModOptionsPressedListener = _listener;
		}

		function onModOptionsPressed()
		{
			this.m.OnModOptionsPressedListener();
		}
	});

	//Need 3 separate hooks, one for each of the 'main' states
	::mods_hookNewObjectOnce("states/world_state", function(o)
	{
		local onInitUI = o.onInitUI;
		o.onInitUI = function()
		{
			onInitUI();
			local mainMenuModule this.m.WorldMenuScreen.getMainMenuModule();
			mainMenuModule.setOnModOptionsPressedListener(this.main_menu_module_onModOptionsPressed.bindenv(this));
		}

		o.main_menu_module_onModOptionsPressed <- function()
		{
			this.MSU.SettingsScreen.show(true);
			this.m.WorldScreen.hide();
			this.m.MenuStack.push(function ()
			{
				this.m.WorldScreen.show();
				this.MSU.SettingsScreen.hide();
			}, function ()
			{
				return !this.MSU.SettingsScreen.isAnimating()
			});
		}
	});

	::mods_hookNewObjectOnce("states/main_menu_state", function(o)
	{
		local onShow = o.onShow; //Not the best hook but can't hook onInit directly
		o.onShow = function()
		{
			local mainMenuModule this.m.MainMenuScreen.getMainMenuModule();
			mainMenuModule.setOnModOptionsPressedListener(this.main_menu_module_onModOptionsPressed.bindenv(this));
			onShow();
		}

		o.main_menu_module_onModOptionsPressed <- function()
		{
			this.MSU.SettingsScreen.show(true);
			this.m.MainMenuScreen.hide();
			this.m.MenuStack.push(function ()
			{
				this.m.MainMenuScreen.show(false);
				this.MSU.SettingsScreen.hide();
			}, function ()
			{
				return !this.MSU.SettingsScreen.isAnimating()
			});
		}
	});

	::mods_hookNewObjectOnce("states/tactical_state", function(o)
	{
		
	});

}
