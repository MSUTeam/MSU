local testSettingsSystem = function()
{
	for (local i = 0; i < 5; ++i)
	{
		local modPanel = this.MSU.Class.SettingsPanel("MSU" + i, "M" + i)
		local numPages = rand() % 5 + 1;
		for (local j = 0; j < numPages; ++j)
		{
			local testPage = this.MSU.Class.SettingsPage("Page" + j, "Page Name " + j);

			local test = this.MSU.Class.RangeSetting("TestRange" + j, 100, 10, 300, 10);
			local test1 = this.MSU.Class.BooleanSetting("TestBool" + j, rand() % 2 == 0, "Test Bool Taro");
			test1.addCallback(function(_data = null){
				this.logInfo("worked?")
			})
			// test1.lock()
			local test2 = this.MSU.Class.BooleanSetting("TestBool" + j + 1, rand() % 2 == 0);
			test2.addFlags("NewCampaign", "NewCampaignOnly")
			local test3 = this.MSU.Class.EnumSetting("TestEnum" + j, ["hi", "hello", "goodbye"], "goodbye");
			test3.lock()
			local test4 = this.MSU.Class.EnumSetting("TestEnum" + j + 1, ["hi", "hello", "goodbye"]);
			local divider = this.MSU.Class.SettingsDivider("divider")

			local test5 = this.MSU.Class.EnumSetting("TestEnum" + j + 2, ["hi", "hello", "goodbye"]);

			testPage.add(test);
			testPage.add(test1);
			testPage.add(test2);
			testPage.add(test3);
			testPage.add(divider);
			testPage.add(test4);
			testPage.add(test5);

			modPanel.addPage(testPage);
		}
		this.MSU.Systems.ModSettings.add(modPanel);
	}
}

this.MSU.Systems.ModSettings <- this.MSU.Class.ModSettingsSystem();
this.MSU.SettingsScreen <- this.new("scripts/ui/mods/msu_settings_screen");

this.MSU.PersistentDataManager <- this.new("scripts/mods/msu_persistent_data_manager");

this.MSU.UI.registerScreenToConnect(this.MSU.SettingsScreen);

::getModSetting <- function( _modID, _settingID )
{
	return this.MSU.Systems.ModSettings.get(_modID).getSetting(_settingID);
}

this.MSU.SettingsFlags <- {
	NewCampaign = {
		required = [
			"NewCampaign"
		]
	}
	World = {
		excluded = [
			"NewCampaignOnly"
		]
	}
	Tactical = {
		excluded = [
			"NewCampaignOnly"
		]
	}
	Main = {
		excluded = [
			"NewCampaignOnly"
		]
	}
}

this.MSU.Systems.ModSettings.registerMod(this.MSU.MSUModName);
local panel = this.MSU.Systems.ModSettings.get(this.MSU.MSUModName);
local logPage = this.MSU.Class.SettingsPage("Logging");
local logToggle = this.MSU.Class.BooleanSetting("logall", false, "Enable all mod logging");
logToggle.addCallback(function(_data){
	this.MSU.Systems.Debug.FullDebug = _data;
})
panel.addPage(logPage);
logPage.add(logToggle);

// this.MSU.Systems.ModSettings.addSetting("MSU", "Logging", "Boolean", "logall", false, "Enable all mod logging", function(_data){
// 	this.MSU.Debug.FullDebug = _data;
// }))

local verboseModeToggle = this.MSU.Class.BooleanSetting("verbose", false, "Enable VerboseMode");
verboseModeToggle.addCallback(function(_data){
	this.Const.AI.VerboseMode = _data
})
logPage.add(verboseModeToggle);

// this.MSU.Systems.ModSettings.importPersistentSettings()


// //this neeeds to be moved into a hook
// this.MSU.PersistentDataManager.loadSettingForEveryMod("Keybind")
// this.MSU.CustomKeybinds.parseForUI();


// Testing Code
testSettingsSystem();
