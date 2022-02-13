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

		function connectScreens() // Want to make this call another function which acts as a very late time to run code, eg I want to lock the settingsmanager at this point (this runs after main menu load)
		{
			foreach (screen in this.Screens)
			{
				screen.connect();
			}
			delete this.MSU.UI.Screens;
		}
	}

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

		o.hideNewCampaignModule <- function()
		{
			this.m.JSHandle.asyncCall("hideNewCampaignModule", null);
		}

		o.showNewCampaignModule <- function()
		{
			this.m.JSHandle.asyncCall("showNewCampaignModule", null);
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
			this.MSU.Systems.ModSettings.updateSettings(_data);
			this.m.MenuStack.pop();
			if (this.m.ModSettingsShown)
			{
				campaign_menu_module_onStartPressed(this.m.TempSettings);
				this.m.TempSettings = null;
				this.m.ModSettingsShown = false;
			}
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
			this.MSU.SettingsScreen.setOnCancelPressedListener(this.msu_settings_screen_onCancelPressed.bindenv(this));
			this.MSU.SettingsScreen.setOnSavePressedListener(this.msu_settings_screen_onSavepressed.bindenv(this));
			this.toggleMenuScreen();
			this.m.WorldScreen.hide();
			this.MSU.SettingsScreen.show(this.MSU.SettingsFlags.World);
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

		o.msu_settings_screen_onCancelPressed <- function ()
		{
			this.m.MenuStack.pop();
		}

		o.msu_settings_screen_onSavepressed <- function( _data )
		{
			this.MSU.Systems.ModSettings.updateSettings(_data);
			this.m.MenuStack.pop();
		}

		local onSerialize = o.onSerialize;
		o.onSerialize = function( _out )
		{
			this.MSU.Systems.ModSettings.flagSerialize();
			onSerialize(_out);
			this.MSU.Systems.ModSettings.resetFlags();
		}

		local onDeserialize = o.onDeserialize;
		o.onDeserialize = function( _in )
		{
			onDeserialize(_in);
			this.MSU.Systems.ModSettings.flagDeserialize();
			this.MSU.Systems.ModSettings.resetFlags();
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
}
