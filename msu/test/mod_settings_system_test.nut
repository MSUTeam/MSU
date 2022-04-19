for (local i = 0; i < 5; ++i)
{
	local modPanel = ::MSU.Mod.ModSettings.getPanel()
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
		test2.Flags.set("NewCampaign", true);
		test2.Flags.set("NewCampaignOnly", true);
		local test3 = ::MSU.Class.EnumSetting("TestEnum" + j, "goodbye", ["hi", "hello", "goodbye"]);
		test3.lock();
		local test4 = ::MSU.Class.EnumSetting("TestEnum" + j + 1,"hi", ["hi", "hello", "goodbye"]);
		local divider = ::MSU.Class.SettingsDivider("divider")

		local test5 = ::MSU.Class.EnumSetting("TestEnum" + j + 2, "hi", ["hi", "hello", "goodbye"]);

		local buttonName = "TestButton" + j
		local buttonTest = ::MSU.Class.ButtonSetting(buttonName, null, "hello?");
		buttonTest.addCallback(function(_data = null){
			this.logInfo("Button " + buttonName + " was pressed");
		})

		testPage.add(test);
		testPage.add(test1);
		testPage.add(test2);
		testPage.add(test3);
		testPage.add(divider);
		testPage.add(test4);
		testPage.add(test5);
		testPage.add(buttonTest);

		modPanel.addPage(testPage);
	}
}
