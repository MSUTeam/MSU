this.ui_screen <- this.inherit("scripts/mods/msu/js_connection", {
	m = {
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

	function destroy()
	{
		this.clearEventListeners();
		this.js_connection.destroy()
	}

	function show(_data)
	{
		if (this.m.JSHandle == null)
		{
			throw this.Exception.NotConnected;
		}
		else if (this.isVisible())
		{
			throw this.Exception.AlreadyInState;
		}
		this.Tooltip.show();
		this.m.JSHandle.asyncCall("show", _data);
	}

	function hide()
	{
		if (this.m.JSHandle == null)
		{
			throw this.Exception.NotConnected;
		}
		else if (!this.isVisible())
		{
			throw this.Exception.AlreadyInState;
		}
		this.Tooltip.hide();
		this.m.JSHandle.asyncCall("hide", null);
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

});
