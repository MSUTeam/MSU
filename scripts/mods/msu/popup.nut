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
		local activeState = ::MSU.Utils.getActiveState();
		switch(activeState.ClassName)
		{
			case "tactical_state":
				activeState.onQuitToMainMenu();
				break;
			case "world_state":
				activeState.exitGame();
				break;
			case "main_menu_state":
				activeState.main_menu_module_onQuitPressed();
				break;
		}
	}
};
