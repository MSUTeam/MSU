::MSU.Mod.Tooltips.setTooltips({
	CharacterStats = ::MSU.Class.CustomTooltip(@(_data) ::TooltipEvents.general_queryUIElementTooltipData(null, "character-stats." + _data.ExtraData, null)),
	Perk = ::MSU.Class.CustomTooltip(function(_data) {
		local filename = _data.ExtraData;
		if (filename in ::MSU.NestedTooltips.PerkIDByFilename) return ::TooltipEvents.general_queryUIPerkTooltipData(null, ::MSU.NestedTooltips.PerkIDByFilename[_data.ExtraData]);
		return ::TooltipEvents.general_querySkillNestedTooltipData(null, null, filename);
	}),
	Skill = ::MSU.Class.CustomTooltip(function(_data) {
		local arr = split(_data.ExtraData, ",");
		local entityId = "entityId" in _data ? _data.entityId : null;
		local skillId = arr.len() > 1 && arr[1] != "null" ? arr[1] : null;
		return ::TooltipEvents.general_querySkillNestedTooltipData(entityId, skillId, arr[0])
	}),
	Item = ::MSU.Class.CustomTooltip(function(_data) {
		local arr = split(_data.ExtraData, ",");
		local entityId = "entityId" in _data ? _data.entityId : null;
		local itemId = arr.len() > 1 && arr[1] != "null" ? arr[1] : null;
		local itemOwner = arr.len() > 2 && arr[2] != "null" ? arr[2] : null;
		return ::TooltipEvents.general_queryItemNestedTooltipData(entityId, itemId, itemOwner, arr[0])
	}),
	ModSettings = {
		Main = {
			Cancel = ::MSU.Class.BasicTooltip("Cancel", "Don't save changes."),
			Reset = ::MSU.Class.BasicTooltip("Reset", "Resets all settings on this page."),
			Apply = ::MSU.Class.BasicTooltip("Apply", "Save all changes from every page without closing the screen."),
			OK = ::MSU.Class.BasicTooltip("Save all changes", "Save all changes from every page and close the screen.")
		},
		Element = {
			Tooltip = ::MSU.Class.CustomTooltip(@(_data) ::getModSetting(_data.elementModId, _data.settingsElementId).getTooltip(_data))
		},
		Keybind = {
			Popup = {
				Cancel = ::MSU.Class.BasicTooltip("Cancel", "Don't save changes."),
				Add = ::MSU.Class.BasicTooltip("Add", "Add another keybind."),
				OK = ::MSU.Class.BasicTooltip("Save", "Save changes."),
				Modify = ::MSU.Class.BasicTooltip("Modify", "Modify this keybind."),
				Delete = ::MSU.Class.BasicTooltip("Delete", "Delete this keybind."),
			}
		}
	}
});

local tooltipImageKeywords = {
	"ui/icons/action_points.png" 		: "CharacterStats+ActionPoints"
	"ui/icons/health.png" 				: "CharacterStats+Hitpoints"
	"ui/icons/morale.png" 				: "CharacterStats+Morale"
	"ui/icons/fatigue.png" 				: "CharacterStats+Fatigue"
	"ui/icons/armor_head.png" 			: "CharacterStats+ArmorHead"
	"ui/icons/armor_body.png" 			: "CharacterStats+ArmorBody"
	"ui/icons/melee_skill.png"  		: "CharacterStats+MeleeSkill"
	"ui/icons/ranged_skill.png" 		: "CharacterStats+RangeSkill"
	"ui/icons/melee_defense.png" 		: "CharacterStats+MeleeDefense"
	"ui/icons/ranged_defense.png" 		: "CharacterStats+RangeDefense"
	"ui/icons/vision.png" 				: "CharacterStats+SightDistance"
	"ui/icons/regular_damage.png" 		: "CharacterStats+RegularDamage"
	"ui/icons/armor_damage.png" 		: "CharacterStats+CrushingDamage"
	"ui/icons/chance_to_hit_head.png" 	: "CharacterStats+ChanceToHitHead"
	"ui/icons/initiative.png" 			: "CharacterStats+Initiative"
	"ui/icons/bravery.png" 				: "CharacterStats+Bravery"
}

::MSU.QueueBucket.AfterHooks.push(function()
{
	foreach (perk in ::Const.Perks.LookupMap)
	{
		local filename = split(perk.Script, "/").top();
		tooltipImageKeywords[perk.Icon] <- "Perk+" + filename;
		::MSU.NestedTooltips.PerkIDByFilename[filename] <- perk.ID;
	}
	::MSU.Mod.Tooltips.setTooltipImageKeywords(tooltipImageKeywords);
});
