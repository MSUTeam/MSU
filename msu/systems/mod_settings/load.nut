local function includeFile( _file )
{
	::includeFile("msu/systems/mod_settings/", _file);
}

includeFile("settings_element.nut");
includeFile("settings_divider.nut");
includeFile("settings_title.nut");

includeFile("abstract_setting.nut");
includeFile("boolean_setting.nut");
includeFile("button_setting.nut");
includeFile("enum_setting.nut");
includeFile("string_setting.nut");
includeFile("keybind_setting.nut");
includeFile("range_setting.nut");

includeFile("settings_page.nut");
includeFile("settings_panel.nut");

includeFile("mod_settings_system.nut");
::MSU.System.ModSettings <- ::MSU.Class.ModSettingsSystem();
includeFile("mod_settings_mod_addon.nut");

::MSU.SettingsScreen <- ::new("scripts/mods/msu/settings_screen");
::MSU.UI.registerConnection(::MSU.SettingsScreen);

::getModSetting <- function( _modID, _settingID )
{
	return ::MSU.System.ModSettings.getPanel(_modID).getSetting(_settingID);
}

::MSU.SettingsFlags <- {
	NewCampaign = {
		required = [
			"NewCampaign"
		]
	},
	World = {
		excluded = [
			"NewCampaignOnly"
		]
	},
	Tactical = {
		excluded = [
			"NewCampaignOnly"
		]
	},
	Main = {
		excluded = [
			"NewCampaignOnly"
		]
	}
};
