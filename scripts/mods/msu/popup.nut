this.popup <- {
	m = {
		JSHandle = null,
		TextCache = [],
	}

	function addLine(_text)
	{
		if (this.m.JSHandle == null)
		{
			this.m.TextCache.push(_text)
		}
		else
		{
			this.m.JSHandle.asyncCall("addLine", _text);
		}
	}

	function addLines(_textArray)
	{
		if (this.m.JSHandle == null)
		{
			this.m.TextCache.extend(_textArray)
		}
		else
		{
			this.m.JSHandle.asyncCall("addLines", _textArray);
		}
	}

	function clearText(_text)
	{
		this.m.JSHandle.asyncCall("clearText", null);
	}

	function show( _useCache = false)
	{
		if(_useCache && this.m.TextCache.len() > 0)
		{
			this.addLines(this.m.TextCache);
			this.m.TextCache = [];
		}
		this.m.JSHandle.asyncCall("show", {
			state = ::MSU.Utils.getActiveState().ClassName
		});
	}

	function setForceQuit( _forceQuit )
	{
		this.m.JSHandle.asyncCall("setForceQuit", _forceQuit);
	}

	function connect()
	{
		this.m.JSHandle = ::UI.connect("MSUPopup", this);
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
