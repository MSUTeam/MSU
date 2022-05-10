this.popup <- {
	m = {
		JSHandle = null,
		TextCache = [],
	}

	function addLine(_text)
	{
		this.m.JSHandle.asyncCall("addLine", _text);
	}

	function addLines(_textArray)
	{
		this.m.JSHandle.asyncCall("addLines", _textArray);
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
		this.m.JSHandle.asyncCall("show", null);
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
		this.finish();
	}
};
