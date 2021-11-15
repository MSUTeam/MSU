this.mod_settings_screen <- this.inherit("scripts/ui/mods/msu_ui_screen", {
	m = {
		MenuStack = null
	},
	
	function create()
	{
		
	}

	function show(_data)
	{
		this.logInfo("show");
		this.logInfo(this.m.JSHandle != null);
		this.logInfo(!this.isVisible());
		if (this.m.JSHandle != null && !this.isVisible())
		{
			this.logInfo("hi");
			this.m.JSHandle.asyncCall("show", this.MSU.SettingsManager.getUIData());
		}
	}

	function connect()
	{
		this.m.JSHandle = this.UI.connect("ModSettingsScreen", this);
		this.logInfo("connect");
	}

	function linkMenuStack( _menuStack )
	{
		this.m.MenuStack = _menuStack;
	}

	function onCancelButtonPressed()
	{
		this.m.MenuStack.pop();
	}
});