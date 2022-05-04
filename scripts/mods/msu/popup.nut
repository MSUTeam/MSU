this.popup <- {
	m = {
		JSHandle = null,
		TextCache = "",
		ForceQuit = false
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

	function forceQuit( _bool )
	{
		this.m.ForceQuit = _bool;
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

	function quitGame()
	{
		// overwritten by mainMenuScreen hook, closes the game
	}
};
