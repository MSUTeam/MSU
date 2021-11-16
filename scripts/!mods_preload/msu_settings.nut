local gt = this.getroottable();

gt.MSU.setupSettingsSystem <- function()
{
	

	this.logInfo("test");

	this.MSU.SettingsManager <- this.new("scripts/mods/mod_settings_manager");
	this.MSU.SettingsScreen <- this.new("scripts/ui/mods/mod_settings_screen");

	local testPage = this.MSU.SettingsPage("TestPage", "MSU");
	local testPage1 = this.MSU.SettingsPage("TestPage1", "MSU1");
	local testPage2 = this.MSU.SettingsPage("TestPage2", "MSU2");
	local testPage3 = this.MSU.SettingsPage("TestPage3", "MSU3");

	for (local i = 0; i < 20; ++i)
	{
		local test = this.MSU.BooleanSetting("TestBool" + i, rand() % 2 == 0);
		testPage.add(test);
	}
	this.MSU.SettingsManager.add(testPage);
	this.MSU.SettingsManager.add(testPage1);
	this.MSU.SettingsManager.add(testPage2);
	this.MSU.SettingsManager.add(testPage3);

	foreach (page in this.MSU.SettingsManager.m.Pages)
	{
		this.logInfo(page.getModID());
	}

}