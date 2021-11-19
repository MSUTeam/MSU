this.mod_settings_screen <- this.inherit("scripts/ui/mods/msu_ui_screen", {
	m = {
		MenuStack = null
	},
	
	function create()
	{
		
	}

	function show(_flags = null)
	{
		if (this.m.JSHandle == null)
		{
			throw this.Exception.NotConnected;
		}
		else if (this.isVisible())
		{
			throw this.Exception.AlreadyVisible;
		}
		this.m.JSHandle.asyncCall("show", this.MSU.SettingsManager.getUIData(_flags));
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
