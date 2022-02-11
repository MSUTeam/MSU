local gt = this.getroottable();

local testSettingsSystem = function()
{

	for (local i = 0; i < 5; ++i)
	{
		local modPanel = this.MSU.SettingsPanel("MSU" + i, "M" + i)
		local numPages = rand() % 5 + 1;
		for (local j = 0; j < numPages; ++j)
		{
			local testPage = this.MSU.SettingsPage("Page" + j, "Page Name " + j);

			local test = this.MSU.RangeSetting("TestRange" + j, 100, 10, 300, 10);
			local test1 = this.MSU.BooleanSetting("TestBool" + j, rand() % 2 == 0, "Test Bool Taro", function(_data = null){
				this.logInfo("worked?")
			});
			test1.lock()
			local test2 = this.MSU.BooleanSetting("TestBool" + j + 1, rand() % 2 == 0);
			test2.addFlags("NewCampaign", "NewCampaignOnly")
			local test3 = this.MSU.EnumSetting("TestEnum" + j, ["hi", "hello", "goodbye"], "goodbye");
			test3.lock()
			local test4 = this.MSU.EnumSetting("TestEnum" + j + 1, ["hi", "hello", "goodbye"]);
			local divider = this.MSU.SettingsDivider("divider")

			local test5 = this.MSU.EnumSetting("TestEnum" + j + 2, ["hi", "hello", "goodbye"]);

			testPage.add(test);
			testPage.add(test1);
			testPage.add(test2);
			testPage.add(test3);
			testPage.add(divider);
			testPage.add(test4);
			testPage.add(test5);

			modPanel.add(testPage);
		}
		this.MSU.SettingsManager.add(modPanel);
	}
}

gt.MSU.setupSettingsSystem <- function()
{
	this.MSU.SettingsManager <- this.new("scripts/mods/msu_settings_manager");
	this.MSU.SettingsScreen <- this.new("scripts/ui/mods/msu_settings_screen");

	this.MSU.PersistentDataManager <- this.new("scripts/mods/msu_persistent_data_manager");

	this.MSU.UI.registerScreenToConnect(this.MSU.SettingsScreen);

	::getModSetting <- function( _modID, _settingID )
	{
		return this.MSU.SettingsManager.get(_modID).get(_settingID);
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

	local panel = this.MSU.SettingsPanel("MSU");
	local logPage = this.MSU.SettingsPage("Logging");
	local logToggle = this.MSU.BooleanSetting("logall", false, "Enable all mod logging");
	logToggle.addCallback(function(_data){
		this.logInfo("I am a callback of " + this.tostring() + " \nChanged to: " + _data)
	})
	this.MSU.SettingsManager.add(panel);
	panel.add(logPage);
	logPage.add(logToggle);


	// Testing Code
	// testSettingsSystem();
}
