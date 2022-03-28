this.settings_screen <- ::inherit("scripts/mods/msu/ui_screen", {
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

	function show( _flags = null )
	{
		if (this.m.JSHandle == null)
		{
			throw ::MSU.Exception.NotConnected;
		}
		else if (this.isVisible())
		{
			throw ::MSU.Exception.AlreadyInState;
		}
		this.m.JSHandle.asyncCall("show", ::MSU.System.ModSettings.getUIData(_flags));
	}

	function connect()
	{
		this.m.JSHandle = ::UI.connect("ModSettingsScreen", this);
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

	function onSettingButtonPressed( _data )
	{
		::MSU.System.ModSettings.onSettingsButtonPressed(_data);
	}
});
