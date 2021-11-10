this.mod_settings_screen <- this.inherit("scripts/mods/ui/msu_ui_screen", {
	m = {},
	
	function create()
	{
		this.m.JSHandle = this.UI.connect("msu_mod_settings_screen", this);
	}

	function show()
	{
		if (this.m.JSHandle != null && !this.isVisible())
		{
			this.Tooltip.show();
			this.m.JSHandle.asyncCall("show", this.MSU.SettingsManager.getUIData());
		}
	}
});