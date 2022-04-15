local generalPage = ::MSU.Class.SettingsPage("General");
::MSU.Mod.ModSettings.addPage(generalPage);

local logToggle = ::MSU.Class.BooleanSetting("logall", false, "Enable all mod logging");
logToggle.addCallback(function(_data)
{
	::MSU.System.Debug.FullDebug = _data;
})
generalPage.add(logToggle);

local ExpandedSkillTooltips = ::MSU.Class.BooleanSetting("ExpandedSkillTooltips", false, "Expanded Skill Tooltips");
ExpandedSkillTooltips.setPersistence(false);
ExpandedSkillTooltips.setDescription("Show MSU-based information in skill tooltips e.g. Damage Type.\n\n[color=" + this.Const.UI.Color.NegativeValue + "]IMPORTANT: [/color]If this setting is enabled automatically, DO NOT disable it as it has been enabled by a mod you are using and is required by that mod.");
generalPage.add(ExpandedSkillTooltips);

local ExpandedItemTooltips = ::MSU.Class.BooleanSetting("ExpandedItemTooltips", false, "Expanded Item Tooltips");
ExpandedItemTooltips.setPersistence(false);
ExpandedItemTooltips.setDescription("Show MSU-based information in item tooltips e.g. Item Type.\n\n[color=" + this.Const.UI.Color.NegativeValue + "]IMPORTANT: [/color]If this setting is enabled automatically, DO NOT disable it as it has been enabled by a mod you are using and is required by that mod.");
generalPage.add(ExpandedItemTooltips);

local verboseModeToggle = ::MSU.Class.BooleanSetting("verbose", false, "AI Verbose Debug Mode");
verboseModeToggle.setDescription("If enabled, sets ::Const.AI.VerboseMode to true for AI related debugging.");
verboseModeToggle.addCallback(function(_data)
{
	::Const.AI.VerboseMode = _data;
})
generalPage.add(verboseModeToggle);

local logPage = ::MSU.Class.SettingsPage("Logging");
::MSU.Mod.ModSettings.addPage(logPage);

local function addLogBool(_flagID)
{
	local boolSetting = ::MSU.Class.BooleanSetting(_flagID + "Log", ::MSU.Mod.Debug.isEnabled(_flagID), ::MSU.String.capitalizeFirst(_flagID) + " Logging");
	boolSetting.addCallback(function(_value)
	{
		::MSU.Mod.Debug.setFlag(_flagID, _value);
	});
	logPage.add(boolSetting);
}

foreach (flag, value in ::MSU.System.Debug.Mods[::MSU.ID])
{
	addLogBool(flag);
}
