local generalPage = ::MSU.Mod.ModSettings.addPage("General");

local expandedSkillTooltips = generalPage.addBooleanSetting("ExpandedSkillTooltips", false, "Expanded Skill Tooltips");
expandedSkillTooltips.setPersistence(false);
expandedSkillTooltips.setDescription("Show MSU-based information in skill tooltips e.g. Damage Type.\n\n[color=" + ::Const.UI.Color.NegativeValue + "]IMPORTANT: [/color]If this setting is enabled automatically, DO NOT disable it as it has been enabled by a mod you are using and is required by that mod.");

local expandedItemTooltips = generalPage.addBooleanSetting("ExpandedItemTooltips", false, "Expanded Item Tooltips");
expandedItemTooltips.setPersistence(false);
expandedItemTooltips.setDescription("Show MSU-based information in item tooltips e.g. Item Type.\n\n[color=" + ::Const.UI.Color.NegativeValue + "]IMPORTANT: [/color]If this setting is enabled automatically, DO NOT disable it as it has been enabled by a mod you are using and is required by that mod.");


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
