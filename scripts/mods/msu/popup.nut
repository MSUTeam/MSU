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
		if (this.m.JSHandle == null)
		{
			if (this.m.TextCache != "") this.m.TextCache += "<br>";
			this.m.TextCache += _text;
		}
		else this.m.JSHandle.asyncCall("addMessage", _text);

	}

	function setState(_state)
	{
		this.m.JSHandle.asyncCall("setState", _state);
	}

	function setTitle(_text)
	{
		this.m.JSHandle.asyncCall("setTitle", _text);
	}

	function setForceQuit( _bool )
	{
		this.m.ForceQuit = _bool;
		if (this.m.JSHandle != null)
			this.m.JSHandle.asyncCall("setForceQuit", _bool);
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
			this.addMessage(this.m.TextCache)
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
