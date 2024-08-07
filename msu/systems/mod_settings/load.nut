local function includeFile( _file )
{
	::MSU.includeFile("msu/systems/mod_settings/", _file);
}

includeFile("settings_element.nut");
includeFile("abstract_setting.nut");
includeFile("elements/string_setting.nut");

foreach (file in ::IO.enumerateFiles("msu/systems/mod_settings/elements/"))
{
	::include(file);
}

includeFile("mod_settings_system");
includeFile("mod_settings_mod_addon");
::MSU.includeFiles(::IO.enumerateFiles("msu/systems/mod_settings"));

::MSU.System.ModSettings <- ::MSU.Class.ModSettingsSystem();
::getModSetting <- function( _modID, _settingID )
{
	return ::MSU.System.ModSettings.getPanel(_modID).getSetting(_settingID);
}

::MSU.SettingsScreen <- ::new("scripts/mods/msu/settings_screen");
::MSU.UI.registerConnection(::MSU.SettingsScreen);
::MSU.UI.addOnConnectCallback(::MSU.System.ModSettings.finalize.bindenv(::MSU.System.ModSettings));
::MSU.System.ModSettings.Screen = ::MSU.SettingsScreen;


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
