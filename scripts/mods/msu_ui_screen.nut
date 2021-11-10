this.msu_ui_screen <- {
	m = {
		JSHandle = null,
		Visible = false,
		Animating = false,
		OnDisconnectedListener = null,
		OnScreenShownListener = null,
		OnScreenHiddenListener = null,
		OnClosePressedListener = null,
	},

	function isVisible()
	{
		return this.m.Visible;
	}

	function isAnimating()
	{
		return this.m.Animating;
	}

	function setOnConnectedListener( _listener )
	{
		this.m.OnConnectedListener = _listener;
	}

	function setOnDisconnectedListener( _listener )
	{
		this.m.OnDisconnectedListener = _listener;
	}
	
	function setOnClosePressedListener( _listener )
	{
		this.m.OnClosePressedListener = _listener;
	}

	function onOkButtonPressed()
	{
		if (this.m.OnOkButtonPressedListener != null)
		{
			this.m.OnOkButtonPressedListener();
		}
	}

	function onCancelButtonPressed()
	{
		if (this.m.OnCancelButtonPressedListener != null)
		{
			this.m.OnCancelButtonPressedListener();
		}
	}

	function clearEventListeners()
	{
		this.m.OnConnectedListener = null;
		this.m.OnDisconnectedListener = null;
		this.m.OnScreenHiddenListener = null;
		this.m.OnScreenShownListener = null;
	}


}