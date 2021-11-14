this.mod_settings_screen <- this.inherit("scripts/ui/mods/msu_ui_screen", {
	m = {},
	
	function create()
	{
		
	}

	function show(_data)
	{
		if (this.m.JSHandle != null && !this.isVisible())
		{
			this.Tooltip.hide();
			this.m.JSHandle.asyncCall("show", this.MSU.SettingsManager.getUIData());
		}
	}

	function connect()
	{
		this.m.JSHandle = this.UI.connect("ModSettingsScreen", this);
	}
});