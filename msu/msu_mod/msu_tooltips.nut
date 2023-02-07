::MSU.Mod.Tooltips.setTooltips({	
	Skill = ::MSU.Class.CustomTooltip(function(_data) {
		local arr = split(_data.ExtraData, ",");
		return ::TooltipEvents.general_querySkillNestedTooltipData("entityId" in _data ? _data.entityId : null, arr.len() > 1 ? arr[1] : null, arr[0])
	}),
	Item = ::MSU.Class.CustomTooltip(function(_data) {
		local arr = split(_data.ExtraData, ",");
		return ::TooltipEvents.general_queryItemNestedTooltipData("entityId" in _data ? _data.entityId : null, arr.len() > 1 ? arr[1] : null, arr.len() > 2 ? arr[2] : null, arr[0])
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
	}
});
