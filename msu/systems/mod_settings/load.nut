local function includeFile( _file )
{
	::includeFile("msu/systems/mod_settings/", _file);
}

includeFile("settings_element.nut");
includeFile("settings_divider.nut");

includeFile("abstract_setting.nut");
includeFile("boolean_setting.nut");
includeFile("enum_setting.nut");
includeFile("string_setting.nut");
includeFile("keybind_setting.nut");
includeFile("range_setting.nut");

includeFile("settings_page.nut");
includeFile("settings_panel.nut");

includeFile("mod_settings_system.nut");
::MSU.System.ModSettings <- ::MSU.Class.ModSettingsSystem();
includeFile("mod_settings_mod_addon.nut");

local testSettingsSystem = function()
{
	for (local i = 0; i < 5; ++i)
	{
		local modPanel = ::MSU.Class.SettingsPanel("MSU" + i, "M" + i);
		local numPages = rand() % 5 + 1;
		for (local j = 0; j < numPages; ++j)
		{
			local testPage = ::MSU.Class.SettingsPage("Page" + j, "Page Name " + j);

			local test = ::MSU.Class.RangeSetting("TestRange" + j, 100, 10, 300, 10);
			local test1 = ::MSU.Class.BooleanSetting("TestBool" + j, rand() % 2 == 0, "Test Bool Taro");
			test1.addCallback(function(_data = null)
			{
				::logInfo("worked?")
			})
			// test1.lock()
			local test2 = ::MSU.Class.BooleanSetting("TestBool" + j + 1, rand() % 2 == 0);
			test2.addFlags("NewCampaign", "NewCampaignOnly");
			local test3 = ::MSU.Class.EnumSetting("TestEnum" + j, "goodbye", ["hi", "hello", "goodbye"]);
			test3.lock();
			local test4 = ::MSU.Class.EnumSetting("TestEnum" + j + 1,"hi", ["hi", "hello", "goodbye"]);
			local divider = ::MSU.Class.SettingsDivider("divider")

			local test5 = ::MSU.Class.EnumSetting("TestEnum" + j + 2, "hi", ["hi", "hello", "goodbye"]);

			testPage.add(test);
			testPage.add(test1);
			testPage.add(test2);
			testPage.add(test3);
			testPage.add(divider);
			testPage.add(test4);
			testPage.add(test5);

			modPanel.addPage(testPage);
		}
		::MSU.System.ModSettings.add(modPanel);
	}
}

::MSU.SettingsScreen <- ::new("scripts/mods/msu/settings_screen");
::MSU.PersistentDataManager <- ::new("scripts/mods/msu/persistent_data_manager");
::MSU.UI.registerConnection(::MSU.SettingsScreen);

::getModSetting <- function( _modID, _settingID )
{
	return ::MSU.System.ModSettings.get(_modID).getSetting(_settingID);
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

local logPage = ::MSU.Class.SettingsPage("Logging");
::MSU.Mod.ModSettings.addPage(logPage);

local logToggle = ::MSU.Class.BooleanSetting("logall", false, "Enable all mod logging");
logToggle.addCallback(function(_data)
{
	::MSU.System.Debug.FullDebug = _data;
})
logPage.add(logToggle);

local expandedSkillDescriptions = ::MSU.Class.BooleanSetting("ExpandedSkillDescriptions", false, "Expanded Skill Descriptions");
logPage.add(expandedSkillDescriptions);

// ::MSU.System.ModSettings.addSetting("MSU", "Logging", "Boolean", "logall", false, "Enable all mod logging", function(_data){
// 	::MSU.Debug.FullDebug = _data;
// }))

local verboseModeToggle = ::MSU.Class.BooleanSetting("verbose", false, "Enable AI Verbose Debug Mode");
verboseModeToggle.addCallback(function(_data)
{
	::Const.AI.VerboseMode = _data;
})
logPage.add(verboseModeToggle);

// ::MSU.System.ModSettings.importPersistentSettings()

// //this neeeds to be moved into a hook
// ::MSU.PersistentDataManager.loadSettingForEveryMod("Keybind")
// ::MSU.CustomKeybinds.parseForUI();

// Testing Code
// testSettingsSystem();
