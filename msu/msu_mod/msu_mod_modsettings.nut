::MSU.Mod.ModSettings.addPage("General");

local expandedSkillTooltips = ::MSU.Mod.ModSettings.addElementToPage("Logging", ::MSU.Class.BooleanSetting("ExpandedSkillTooltips", false, "Expanded Skill Tooltips"));
expandedSkillTooltips.setPersistence(false);
expandedSkillTooltips.setDescription("Show MSU-based information in skill tooltips e.g. Damage Type.\n\n[color=" + this.Const.UI.Color.NegativeValue + "]IMPORTANT: [/color]If this setting is enabled automatically, DO NOT disable it as it has been enabled by a mod you are using and is required by that mod.");

local expandedItemTooltips = :MSU.Mod.ModSettings.addElementToPage("General", ::MSU.Class.BooleanSetting("ExpandedItemTooltips", false, "Expanded Item Tooltips"));
expandedItemTooltips.setPersistence(false);
expandedItemTooltips.setDescription("Show MSU-based information in item tooltips e.g. Item Type.\n\n[color=" + this.Const.UI.Color.NegativeValue + "]IMPORTANT: [/color]If this setting is enabled automatically, DO NOT disable it as it has been enabled by a mod you are using and is required by that mod.");


::MSU.Mod.ModSettings.addPage("Logging");

foreach (flagID, value in ::MSU.System.Debug.Mods[::MSU.ID])
{
	local boolSetting = :MSU.Mod.ModSettings.addElementToPage("Logging", ::MSU.Class.BooleanSetting(flagID + "Log", value, ::MSU.String.capitalizeFirst(flagID) + " Logging"));
	boolSetting.getFlags().set("FlagID", flagID);
	boolSetting.addCallback(function(_value)
	{
		::MSU.Mod.Debug.setFlag(this.getFlags().get("FlagID"), _value);
	});
}

::MSU.Mod.ModSettings.addDividerToPage("Logging");

local verboseModeToggle = ::MSU.Mod.ModSettings.addElementToPage("Logging", ::MSU.Class.BooleanSetting("verbose", false, "AI Behavior logging"));
verboseModeToggle.setDescription("If enabled, sets ::Const.AI.VerboseMode to true for AI related debugging.");
verboseModeToggle.addCallback(function(_data)
{
	::Const.AI.VerboseMode = _data;
})

local logToggle = ::MSU.Mod.ModSettings.addElementToPage("Logging", ::MSU.Class.BooleanSetting("logall", false, "Enable all mod logging"));
logToggle.setDescription("If enabled, enables every debug flag for every mod.");
logToggle.addCallback(function(_data)
{
	::MSU.System.Debug.FullDebug = _data;
})

