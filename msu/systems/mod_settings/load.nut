local function includeFile( _file )
{
	::includeFile("msu/systems/mod_settings/", _file);
}

includeFile("settings_element.nut");
includeFile("settings_divider.nut");

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

::MSU.Mod.register(::MSU.System.ModSettings);

local generalPage = ::MSU.Class.SettingsPage("General");
::MSU.Mod.ModSettings.addPage(generalPage);

local logToggle = ::MSU.Class.BooleanSetting("logall", false, "Enable all mod logging");
logToggle.addCallback(function(_data)
{
	::MSU.System.Debug.FullDebug = _data;
})
generalPage.add(logToggle);

local expandedSkillDescriptions = ::MSU.Class.BooleanSetting("ExpandedSkillDescriptions", false, "Expanded Skill Descriptions");
expandedSkillDescriptions.setChangeLogging(false);
expandedSkillDescriptions.setDescription("Show MSU-based information in skill tooltips e.g. Damage Type.\n\n[color=" + this.Const.UI.Color.NegativeValue + "]IMPORTANT: [/color]If this setting is enabled automatically, DO NOT disable it as it has been enabled by a mod you are using and is required by that mod.");
generalPage.add(expandedSkillDescriptions);

local expandedItemDescriptions = ::MSU.Class.BooleanSetting("ExpandedItemDescriptions", false, "Expanded Item Descriptions");
expandedItemDescriptions.setChangeLogging(false);
expandedItemDescriptions.setDescription("Show MSU-based information in item tooltips e.g. Item Type.\n\n[color=" + this.Const.UI.Color.NegativeValue + "]IMPORTANT: [/color]If this setting is enabled automatically, DO NOT disable it as it has been enabled by a mod you are using and is required by that mod.");
generalPage.add(expandedItemDescriptions);

local verboseModeToggle = ::MSU.Class.BooleanSetting("verbose", false, "AI Verbose Debug Mode");
verboseModeToggle.setDescription("If enabled, sets ::Const.AI.VerboseMode to true for AI related debugging.");
verboseModeToggle.addCallback(function(_data)
{
	::Const.AI.VerboseMode = _data;
})
generalPage.add(verboseModeToggle);
