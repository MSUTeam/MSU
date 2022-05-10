::mods_hookExactClass("states/tactical_state", function(o) {
	local executeEntityTravel = o.executeEntityTravel;
	o.executeEntityTravel = function( _activeEntity, _mouseEvent )
	{
		_activeEntity.getSkills().m.IsPreviewing = false;
		executeEntityTravel(_activeEntity, _mouseEvent);
	}

	local executeEntitySkill = o.executeEntitySkill;
	o.executeEntitySkill = function( _activeEntity, _targetTile )
	{
		_activeEntity.getSkills().m.IsPreviewing = false;
		executeEntitySkill(_activeEntity, _targetTile);
	}

	local onInitUI = o.onInitUI;
	o.onInitUI = function()
	{
		onInitUI();
		local mainMenuModule = this.m.TacticalMenuScreen.getMainMenuModule();
		mainMenuModule.setOnModOptionsPressedListener(this.main_menu_module_onModOptionsPressed.bindenv(this));
	}

	o.main_menu_module_onModOptionsPressed <- function()
	{
		::MSU.SettingsScreen.setOnCancelPressedListener(this.msu_settings_screen_onCancelPressed.bindenv(this));
		::MSU.SettingsScreen.setOnSavePressedListener(this.msu_settings_screen_onSavepressed.bindenv(this));
		this.m.TacticalMenuScreen.hide();
		::MSU.SettingsScreen.show(::MSU.SettingsFlags.Tactical);
		this.m.MenuStack.push(function ()
		{
			::MSU.SettingsScreen.hide();
			local allowRetreat = this.m.StrategicProperties == null || !this.m.StrategicProperties.IsFleeingProhibited;
			local allowQuit = !this.isScenarioMode();
			this.m.TacticalMenuScreen.show(allowRetreat, allowQuit, !this.isScenarioMode() && ::World.Assets.isIronman() ? "Quit & Retire" : "Quit");
		}, function ()
		{
			return !::MSU.SettingsScreen.isAnimating();
		});
	}

	o.msu_settings_screen_onCancelPressed <- function ()
	{
		this.m.MenuStack.pop();
	}

	o.msu_settings_screen_onSavepressed <- function( _data )
	{
		::MSU.System.ModSettings.updateSettings(_data);
		this.m.MenuStack.pop();
	}

	local onKeyInput = o.onKeyInput;
	o.onKeyInput = function( _key )
	{
		if (!::MSU.Key.isKnownKey(_key))
		{
			return onKeyInput(_key);
		}
		if (::MSU.System.Keybinds.onKeyInput(_key, this, ::MSU.Key.State.Tactical))
		{
			return false;
		}
		return onKeyInput(_key);
	}

	local onMouseInput = o.onMouseInput;
	o.onMouseInput = function( _mouse )
	{
		if (!::MSU.Key.isKnownMouse(_mouse))
		{
			return onMouseInput(_mouse);
		}
		if (::MSU.System.Keybinds.onMouseInput(_mouse, this, ::MSU.Key.State.Tactical))
		{
			return false;
		}
		return onMouseInput(_mouse);
	}

	local toggleMenuScreen = o.toggleMenuScreen; // VANILLAFIX https://steamcommunity.com/app/365360/discussions/1/3276942370896011321/
	o.toggleMenuScreen = function()
	{
		if (this.m.TacticalMenuScreen.isAnimating()) return false;
		return toggleMenuScreen();
	}
});
