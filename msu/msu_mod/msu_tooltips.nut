::MSU.Mod.Tooltips.setTooltips({	
	Skill = ::MSU.Class.CustomTooltip(function(_data) {
		local arr = split(_data.ExtraData, ",");
		return ::TooltipEvents.general_querySkillNestedTooltipData("entityId" in _data ? _data.entityId : null, arr.len() > 1 ? arr[1] : null, arr[0])
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
