this.getroottable().MSU.registerUIFiles <- function()
{
	::mods_registerCSS("msu_css.css");
	::mods_registerJS("msu_ui_screen.js");
	::mods_registerJS("msu_mod_settings_screen.js");
	::mods_registerJS("msu_mod_screens.js");
	::mods_registerJS("z_temp.js")

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

		o.connectModUIs <- function()
		{
			//This system should be expanded into a proper MSU thing (allow modded UIs to connect as main menu loads)
			this.MSU.SettingsScreen.connect();
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
			this.MSU.SettingsScreen.show(true);
			this.m.MainMenuScreen.hide();
			this.m.MenuStack.push(function ()
			{
				this.m.MainMenuScreen.show(false);
				this.MSU.SettingsScreen.hide();
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
			this.m.WorldScreen.hide()
			this.MSU.SettingsScreen.show(true);
			this.m.MenuStack.push(function ()
			{
				this.MSU.SettingsScreen.hide();
				this.m.WorldScreen.show()
				this.toggleMenuScreen();
			}, function ()
			{
				return !this.MSU.SettingsScreen.isAnimating()
			});
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
				return !this.MSU.SettingsScreen.isAnimating()
			});
		}
	});
}
