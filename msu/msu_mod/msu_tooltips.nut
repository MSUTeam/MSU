::MSU.TooltipIdentifiers <- {
	ModSettings = {
		Main = {
			Cancel = ::MSU.Class.BasicTooltip("Cancel", "Don't save changes."),
			OK = ::MSU.Class.BasicTooltip("Save all changes", "Save all changes from every page.")
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
}
::MSU.Tooltip.addTooltips("MSU", ::MSU.TooltipIdentifiers);
