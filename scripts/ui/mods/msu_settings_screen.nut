this.msu_settings_screen <- this.inherit("scripts/ui/mods/msu_ui_screen", {
	m = {
		MenuStack = null,
		OnCancelPressedListener = null,
		OnSavePressedListener = null
	},
	
	function create()
	{
		
	}

	function setOnSavePressedListener( _listener )
	{
		this.m.OnSavePressedListener = _listener;
	}

	function setOnCancelPressedListener( _listener )
	{
		this.m.OnCancelPressedListener = _listener;
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
		this.m.OnCancelPressedListener();
	}

	function onSaveButtonPressed( _data )
	{
		this.m.OnSavePressedListener(_data);
	}
});
