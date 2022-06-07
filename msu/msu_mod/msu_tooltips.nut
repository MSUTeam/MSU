::MSU.Mod.Tooltips.setTooltips({
	ModSettings = {
		Main = {
			Cancel = ::MSU.Class.BasicTooltip("Cancel", "Don't save changes."),
			OK = ::MSU.Class.BasicTooltip("Save all changes", "Save all changes from every page.")
		},
		Element = {
			Tooltip = ::MSU.Class.CustomTooltip(@(_data) ::getModSetting(_data.elementModId, _data.settingsElementId).getTooltip(_data))
		},
		Keybind = {
			Popup = {
				Cancel = {
					Title = "Cancel",
					Description = "Don't save changes."
				},
				Add = {
					Title = "Add",
					Description = "Add another keybind."
				},
				OK = {
					Title = "Save",
					Description = "Save changes."
				},
				Modify = {
					Title = "Modify",
					Description = "Modify this keybind."
				},
				Delete = {
					Title = "Delete",
					Description = "Delete this keybind."
				},
			}
		}
	}
});
