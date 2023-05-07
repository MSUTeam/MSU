this.popup <- {
	m = {
		Visible = false,
		Animating = false,
		JSHandle = null,
		States = {
			None = 0,
			Small = 1,
			Full = 2
		}
		ForceQuit = false,
		FunctionBuffer = [],
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
			this.m.FunctionBuffer.push(function(){
				this.addMessage(_text);
			})
			return;
		}
		this.m.JSHandle.asyncCall("addMessage", _text);

	}

	function setState(_state)
	{
		if (this.m.JSHandle == null)
		{
			this.m.FunctionBuffer.push(function(){
				this.setState(_state);
			})
			return;
		}
		this.m.JSHandle.asyncCall("setState", _state);
	}

	function setTitle(_text)
	{
		if (this.m.JSHandle == null)
		{
			this.m.FunctionBuffer.push(function(){
				this.setTitle(_text);
			})
			return;
		}
		this.m.JSHandle.asyncCall("setTitle", _text);
	}

	function setForceQuit( _bool )
	{
		this.m.ForceQuit = _bool;
		if (this.m.JSHandle == null)
		{
			this.m.FunctionBuffer.push(function(){
				this.setForceQuit(_bool);
			})
			return;
		}
		this.m.JSHandle.asyncCall("setForceQuit", _bool);
	}

	function isForceQuitting()
	{
		return this.m.ForceQuit;
	}

	function connect()
	{
		this.m.JSHandle = ::UI.connect("MSUPopup", this);
		if (this.m.FunctionBuffer.len() > 0)
		{
			foreach (func in this.m.FunctionBuffer)
			{
				func.call(this);
			}
		}
		delete this.m.FunctionBuffer;
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
