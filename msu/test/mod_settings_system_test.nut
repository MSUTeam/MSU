for (local i = 0; i < 5; ++i)
{
	local numPages = rand() % 5 + 1;
	for (local j = 0; j < numPages; ++j)
	{
		local testPage = ::MSU.Mod.ModSettings.addPage("Page" + j, "Page Name " + j);
		testPage.addDivider("dividertest");
		testPage.addTitle("titleTest", "Test Title");
		local test = testPage.addRangeSetting("TestRange" + j, 100, 10, 300, 10);
		local test1 = testPage.addBooleanSetting("TestBool" + j, rand() % 2 == 0, "Test Bool Taro");
		test1.addCallback(function(_data = null)
		{
			::logInfo("worked?")
		})
		// test1.lock()
		local test2 = testPage.addBooleanSetting("TestBool" + j + 1, rand() % 2 == 0);
		test2.Flags.set("NewCampaign", true);
		test2.Flags.set("NewCampaignOnly", true);
		local test3 = testPage.addEnumSetting("TestEnum" + j, "goodbye", ["hi", "hello", "goodbye"]);
		test3.lock();
		local test4 = testPage.addEnumSetting("TestEnum" + j + 1,"hi", ["hi", "hello", "goodbye"]);

		local test5 = testPage.addEnumSetting("TestEnum" + j + 2, "hi", ["hi", "hello", "goodbye"]);

		local buttonName = "TestButton" + j
		local buttonTest = testPage.addButtonSetting(buttonName, null, "hello?");
		buttonTest.addCallback(function(_data = null){
			this.logInfo("Button " + buttonName + " was pressed");
		})
		local stringTest = testPage.addStringSetting("teststring", "string work?", "hello?");
	}
}
