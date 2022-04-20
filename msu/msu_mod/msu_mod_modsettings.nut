local generalPage = ::MSU.Mod.ModSettings.addPage("General");

local expandedSkillTooltips = generalPage.add(::MSU.Class.BooleanSetting("ExpandedSkillTooltips", false, "Expanded Skill Tooltips"));
expandedSkillTooltips.setPersistence(false);
expandedSkillTooltips.setDescription("Show MSU-based information in skill tooltips e.g. Damage Type.\n\n[color=" + this.Const.UI.Color.NegativeValue + "]IMPORTANT: [/color]If this setting is enabled automatically, DO NOT disable it as it has been enabled by a mod you are using and is required by that mod.");

local expandedItemTooltips = generalPage.add(::MSU.Class.BooleanSetting("ExpandedItemTooltips", false, "Expanded Item Tooltips"));
expandedItemTooltips.setPersistence(false);
expandedItemTooltips.setDescription("Show MSU-based information in item tooltips e.g. Item Type.\n\n[color=" + this.Const.UI.Color.NegativeValue + "]IMPORTANT: [/color]If this setting is enabled automatically, DO NOT disable it as it has been enabled by a mod you are using and is required by that mod.");


local logPage = ::MSU.Mod.ModSettings.addPage("Logging");
logPage.add(::MSU.Class.SettingsDivider("msu_logging", "MSU Logging"));

foreach (flagID, value in ::MSU.System.Debug.Mods[::MSU.ID])
{
	local boolSetting = logPage.add(::MSU.Class.BooleanSetting(flagID + "Log", value, ::MSU.String.capitalizeFirst(flagID) + " Logging"));
	boolSetting.Flags.set("FlagID", flagID);
	boolSetting.addCallback(function(_value)
	{
		::MSU.Mod.Debug.setFlag(this.Flags.get("FlagID"), _value);
	});
}

logPage.add(::MSU.Class.SettingsDivider("global_logging", "Global Logging"));
local verboseModeToggle = logPage.add(::MSU.Class.BooleanSetting("verbose", false, "AI Behavior logging"));
verboseModeToggle.setDescription("If enabled, sets ::Const.AI.VerboseMode to true for AI related debugging.");
verboseModeToggle.addCallback(function(_data)
{
	::Const.AI.VerboseMode = _data;
})

local logToggle = logPage.add(::MSU.Class.BooleanSetting("logall", false, "Enable all mod logging"));
logToggle.setDescription("If enabled, considers every debug flag for every mod enabled, regardless of flag status.");
logToggle.addCallback(function(_data)
{
	::MSU.System.Debug.FullDebug = _data;
})
