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

	function create()
	{
		
	}

	function connect()
	{
		//Needs a UI Bind:
		//this.m.JSHandle = this.UI.connect("path/to/ui_screen.", this);
	}

	function destroy()
	{
		this.clearEventListeners();
		this.m.JSHandle = this.UI.disconnect(this.m.JSHandle);
	}

	function show(_data)
	{
		if (this.m.JSHandle != null && !this.isVisible())
		{
			this.Tooltip.show();
			this.m.JSHandle.asyncCall("show", _data);
		}
	}

	function hide()
	{
		if (this.m.JSHandle != null && this.isVisible())
		{
			this.Tooltip.hide();
			this.m.JSHandle.asyncCall("hide", null);
		}
	}

	function onScreenConnected()
	{
		if (this.m.OnConnectedListener != null)
		{
			this.m.OnConnectedListener();
		}
	}

	function onScreenDisconnected()
	{
		if (this.m.OnDisconnectedListener != null)
		{
			this.m.OnDisconnectedListener();
		}
	}

	function onScreenShown()
	{
		this.m.Visible = true;
		this.m.Animating = false;
		this.logInfo("Screen Shown");
	}

	function onScreenHidden()
	{
		this.m.Visible = false;
		this.m.Animating = false;

	}

	function onScreenAnimating()
	{
		this.m.Animating = true;
	}

	function isConnected()
	{
		return this.m.JSHandle != null;
	}

}