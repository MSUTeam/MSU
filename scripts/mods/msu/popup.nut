this.popup <- {
	m = {
		Visible = false,
		Animating = false,
		JSHandle = null,
		TextCache = "",
		ForceQuit = false
	}

	function isVisible()
	{
		return this.m.Visible;
	}

	function isAnimating()
	{
		return this.m.Animating;
	}

	function showRawText( _text, _forceQuit = false )
	{
		if (_forceQuit) this.m.ForceQuit = true;
		if (this.m.JSHandle == null)
		{
			if (this.m.TextCache != "") this.m.TextCache += "<br>";
			this.m.TextCache += _text;
		}
		else
		{
			local data = {
				forceQuit = this.m.ForceQuit,
				text = _text
			}
			this.m.JSHandle.asyncCall("showRawText", data);
		}
	}

	function showModUpdates( _modInfos )
	{
		this.m.JSHandle.asyncCall("showModUpdates", _modInfos);
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
		for (local i = 0; i < 20; ++i) // for testing to force scroll
		{
			this.showRawText("asdf" + i)
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
