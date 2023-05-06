this.popup <- {
	m = {
		Visible = false,
		Animating = false,
		JSHandle = null,
		TextCache = "",
		ForceQuit = false,
		States = {
			None = 0,
			Small = 1,
			Full = 2
		}
	}

	function isVisible()
	{
		return this.m.Visible;
	}

	function isAnimating()
	{
		return this.m.Animating;
	}

	function addMessage(_text)
	{
		this.m.JSHandle.asyncCall("addMessage", _text);
	}

	function setState(_state)
	{
		this.m.JSHandle.asyncCall("setState", _state);
	}

	function showRawText( _text, _forceQuit = false, _state = null )
	{
		if (_forceQuit) this.m.ForceQuit = true;
		if (this.m.JSHandle == null)
		{
			if (this.m.TextCache != "") this.m.TextCache += "<br>";
			this.m.TextCache += _text;
		}
		else
		{
			if (this.m.ForceQuit)
				this.m.JSHandle.asyncCall("setForceQuit", null);
			this.addMessage(_text);
			if (_state != null)
				this.setState(_state);
		}
	}

	function forceQuit( _bool )
	{
		this.m.ForceQuit = _bool;
	}

	function isForceQuitting()
	{
		return this.m.ForceQuit;
	}

	function connect()
	{
		this.m.JSHandle = ::UI.connect("MSUPopup", this);
		if (this.m.TextCache != "")
		{
			this.showRawText(this.m.TextCache)
			this.m.TextCache = "";
		}
	}

	function hide()
	{
		this.m.JSHandle.asyncCall("hide", null);
	}

	function quitGame()
	{
		// overwritten by mainMenuScreen hook, closes the game
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
};
