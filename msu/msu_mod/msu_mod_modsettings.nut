local generalPage = ::MSU.Mod.ModSettings.addPage("General");

local expandedSkillTooltips = generalPage.addBooleanSetting("ExpandedSkillTooltips", false, "Expanded Skill Tooltips");
expandedSkillTooltips.setPersistence(false);
expandedSkillTooltips.setDescription("Show MSU-based information in skill tooltips e.g. Damage Type.");

local expandedItemTooltips = generalPage.addBooleanSetting("ExpandedItemTooltips", false, "Expanded Item Tooltips");
expandedItemTooltips.setPersistence(false);
expandedItemTooltips.setDescription("Show MSU-based information in item tooltips e.g. Item Type.");

local resetAllSettingsButton = generalPage.addButtonSetting("ResetAllSettings", null, "Reset ALL Settings");
resetAllSettingsButton.setDescription("Reset all settings for every mod.");
resetAllSettingsButton.addCallback(function(_data = null){
	foreach (panel in ::MSU.System.ModSettings.getPanels()) panel.resetSettings();
})

local suppressBaseKeybinds = generalPage.addBooleanSetting("SuppressBaseKeybinds", false, "Suppress base keybinds");
suppressBaseKeybinds.setDescription("Whether base keybinds should be suppressed. This means that only the MSU system will be used for keybinds.\nFor example, if you set 'Open Character Screen' from 'c' to 'tab' then without this setting, pressing 'c' will still open the character screen if no other MSU keybind is bound to c. With this setting, only 'tab' will open it.");

local blockSQInput = generalPage.addBooleanSetting("blockSQInput", true, "Don't use keybinds when writing text");
blockSQInput.setDescription("Whether keybinds should be blocked when you are writing text.\nBy default, writing text in something like a 'change name' popup will still allow normal game keybinds to work. For example, writing a 'c' would open the stash screen.\nMSU disables game keybinds when you're writing something, but there might be issues with some mods.\nKeep this enabled unless you're having issues with keybinds not working properly.");
blockSQInput.addAfterChangeCallback(@ (_oldValue) ::MSU.System.Keybinds.InputDenied = false); // use it as an opportunity to reset

local vanillaBBCode = generalPage.addBooleanSetting("VanillaBBCode", false, "Enable Bold Vanilla Text");
vanillaBBCode.setDescription("Toggles vanilla bold font modifications being applied, in vanilla these don't work, but are still in the code for some reason, when MSU fixes this behavior to work for mods, suddenly these will apply in vanilla as well.\nThis will make some text look [mb]Bold[/mb].");
vanillaBBCode.addCallback(@ (_value) ::MSU.UI.JSConnection.onVanillaBBCodeUpdated(_value));

local logPage = ::MSU.Mod.ModSettings.addPage("Logging");

logPage.addTitle("msu_log", "MSU Logging");
logPage.addDivider("msu_divider");

foreach (flagID, value in ::MSU.System.Debug.Mods[::MSU.ID])
{
	local boolSetting = logPage.addBooleanSetting(flagID + "Log", value, ::MSU.String.capitalizeFirst(flagID));
	boolSetting.Data.FlagID <- flagID;
	boolSetting.addCallback(function(_value)
	{
		::MSU.Mod.Debug.setFlag(this.Data.FlagID, _value);
	});
}

logPage.addTitle("global_log", "Global Logging");
logPage.addDivider("global_divider");

local verboseModeToggle = logPage.addBooleanSetting("verbose", false, "AI Behavior logging");
verboseModeToggle.setDescription("If enabled, sets ::Const.AI.VerboseMode to true for AI related debugging.");
verboseModeToggle.addCallback(function(_data)
{
	::Const.AI.VerboseMode = _data;
})

local logToggle = logPage.addBooleanSetting("logall", false, "All mod logging");
logToggle.setDescription("If enabled, considers every debug flag for every mod enabled, regardless of flag status.");
logToggle.addCallback(function(_data)
{
	::MSU.System.Debug.FullDebug = _data;
})
