this.getroottable().MSU.setupUI <- function()
{
	::mods_registerCSS("msu_css.css");
	::mods_registerJS("msu_ui_screen.js");

	::mods_registerJS("msu_settings_screen.js");
	::mods_registerCSS("msu_settings_screen.css");

	::mods_registerJS("msu_mod_screens.js");

	::mods_registerJS("~~msu_connect_screens.js")

	this.MSU.UI <- {
		Screens = [],

		function registerScreenToConnect(_screen)
		{
			this.Screens.push(_screen);
		}

		function connectScreens()
		{
			foreach (screen in this.Screens)
			{
				screen.connect();
			}
		}
	}

	//Uncertain if we want all hooks in their own file with mod_ prefixes

	::mods_hookNewObjectOnce("ui/screens/menu/main_menu_screen", function(o)
	{
		o.showMainMenuModule <- function()
		{
			this.m.JSHandle.asyncCall("showMainMenuModule", null);
		}

		o.hideMainMenuModule <- function()
		{
			this.m.JSHandle.asyncCall("hideMainMenuModule", null);
		}
	});

	::mods_hookExactClass("ui/screens/menu/modules/main_menu_module", function(o)
	{
		o.m.OnModOptionsPressedListener <- null;

		o.setOnModOptionsPressedListener <- function( _listener )
		{
			this.m.OnModOptionsPressedListener = _listener;
		}

		o.onModOptionsButtonPressed <- function()
		{
			this.m.OnModOptionsPressedListener();
		}

		o.connectModScreens <- function()
		{
			this.MSU.UI.connectScreens();
		}
	});

	//Need 3 separate hooks, one for each of the 'main' states

	::mods_hookNewObjectOnce("states/main_menu_state", function(o)
	{
		local show = o.show; //Not the best hook but can't hook onInit directly
		o.show = function()
		{
			local mainMenuModule = this.m.MainMenuScreen.getMainMenuModule();
			mainMenuModule.setOnModOptionsPressedListener(this.main_menu_module_onModOptionsPressed.bindenv(this));
			show();
		}

		o.main_menu_module_onModOptionsPressed <- function()
		{
			this.MSU.SettingsScreen.linkMenuStack(this.m.MenuStack);
			this.m.MainMenuScreen.hideMainMenuModule();
			this.MSU.SettingsScreen.show(true);
			this.m.MenuStack.push(function ()
			{
				this.MSU.SettingsScreen.hide();
				this.m.MainMenuScreen.showMainMenuModule();
			}, function ()
			{
				return !this.MSU.SettingsScreen.isAnimating();
			});
		}
	});

	::mods_hookNewObjectOnce("states/world_state", function(o)
	{
		local onInitUI = o.onInitUI;
		o.onInitUI = function()
		{
			onInitUI();
			local mainMenuModule = this.m.WorldMenuScreen.getMainMenuModule();
			mainMenuModule.setOnModOptionsPressedListener(this.main_menu_module_onModOptionsPressed.bindenv(this));
		}

		o.main_menu_module_onModOptionsPressed <- function()
		{
			this.MSU.SettingsScreen.linkMenuStack(this.m.MenuStack);
			this.toggleMenuScreen();
			this.m.WorldScreen.hide();
			this.MSU.SettingsScreen.show(true);
			this.m.MenuStack.push(function ()
			{
				this.MSU.SettingsScreen.hide();
				this.m.WorldScreen.show();
				this.toggleMenuScreen();
			}, function ()
			{
				return !this.MSU.SettingsScreen.isAnimating();
			});
		}

		local onSerialize = o.onSerialize;
		o.onSerialize = function( _out )
		{
			this.MSU.SettingsManager.flagSerialize();
			onSerialize(_out);
			this.MSU.SettingsManager.resetFlags();
		}

		local onDeserialize = o.onDeserialize;
		o.onDeserialize = function( _in )
		{
			onDeserialize(_in);
			this.MSU.SettingsManager.flagDeserialize();
			this.MSU.SettingsManager.resetFlags();
		}
	});

	::mods_hookNewObjectOnce("states/tactical_state", function(o)
	{
		local onInitUI = o.onInitUI;
		o.onInitUI = function()
		{
			onInitUI();
			local mainMenuModule = this.m.TacticalMenuScreen.getMainMenuModule();
			mainMenuModule.setOnModOptionsPressedListener(this.main_menu_module_onModOptionsPressed.bindenv(this));
		}

		o.main_menu_module_onModOptionsPressed <- function()
		{
			this.MSU.SettingsScreen.linkMenuStack(this.m.MenuStack);
			this.m.TacticalMenuScreen.hide();
			this.MSU.SettingsScreen.show(true);
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
	});
}
