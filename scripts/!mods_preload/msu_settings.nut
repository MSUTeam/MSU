local gt = this.getroottable();

local testSettingsSystem = function()
{

	for (local i = 0; i < 5; ++i)
	{
		local modPanel = this.MSU.SettingsModPanel("MSU" + i, "M" + i)
		local numPages = rand() % 5 + 1;
		for (local j = 0; j < numPages; ++j)
		{
			local testPage = this.MSU.SettingsPage("Page" + j, "Page Name " + j);

			local test = this.MSU.RangeSetting("TestRange" + j, 100, 10, 300, 10);
			local test1 = this.MSU.BooleanSetting("TestBool" + j, rand() % 2 == 0);
			test1.lock()
			local test2 = this.MSU.BooleanSetting("TestBool" + j + 1, rand() % 2 == 0);
			test2.addFlags(["NewCampaign", "NewCampaignOnly"])
			local test3 = this.MSU.EnumSetting("TestEnum" + j, ["hi", "hello", "goodbye"], "goodbye");
			test3.lock()
			local test4 = this.MSU.EnumSetting("TestEnum" + j + 1, ["hi", "hello", "goodbye"]);
			local divider = this.MSU.Divider("divider")

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
	this.MSU.SettingsManager <- this.new("scripts/mods/mod_settings_manager");
	this.MSU.SettingsScreen <- this.new("scripts/ui/mods/mod_settings_screen");

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
				"NotWorld", "NewCampaignOnly", "TacticalOnly", "MainOnly"
			]
		}
		Tactical = {
			excluded = [
				"NotTactical", "NewCampaignOnly", "MainOnly", "WorldOnly"
			]
		}
		Main = {
			excluded = [
				"NotMain", "NewCampaignOnly", "TacticalOnly", "WorldOnly"
			]
		}
	}

	// Testing Code
	// testSettingsSystem();
}