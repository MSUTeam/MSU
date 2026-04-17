::MSU.Mod.Tooltips.setTooltips({
	LoadCampaign = ::MSU.Class.CustomTooltip(function( _data ) {
		local ret = [
			{ contentType = "settlement-status-effect"},
			{
				id = 1,
				type = "title",
				text = "Mod Incompatibility"
			},
			{
				id = 2,
				type = "description",
				text = "Detected by MSU"
			}
		];
		foreach (e in _data.errors)
		{
			ret.push({
				id = 2,
				type = "text",
				icon = "ui/icons/warning.png",
				text = e
			});
		}
		return ret;
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
