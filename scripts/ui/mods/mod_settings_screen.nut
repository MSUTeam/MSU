this.mod_settings_screen <- this.inherit("scripts/ui/mods/msu_ui_screen", {
	m = {
		MenuStack = null
	},
	
	function create()
	{
		
	}

	function show(_data)
	{
		if (this.m.JSHandle != null && !this.isVisible())
		{
			this.m.JSHandle.asyncCall("show", this.MSU.SettingsManager.getUIData());
		}
	}

	function connect()
	{
		this.m.JSHandle = this.UI.connect("ModSettingsScreen", this);
	}

	function linkMenuStack( _menuStack )
	{
		this.m.MenuStack = _menuStack;
	}

	function onCancelButtonPressed()
	{
		this.m.MenuStack.pop();
	}

	function onSaveButtonPressed( _data )
	{
		this.MSU.SettingsManager.updateSettings(_data);
		this.m.MenuStack.pop();
	}
});