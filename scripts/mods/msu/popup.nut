this.popup <- {
	m = {
		Visible = false,
		Animating = false,
		JSHandle = null,
		TextCache = "",
		ForceQuit = false,
		ModUpdateHash = "",
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
		// check if the user clicked the 'don't remind me' button last time and it's still the same mods wanting updates
		local modsWithNewVersionsString = "";
		foreach (_, modUpdateInfo in _modInfos)
		{
			modsWithNewVersionsString += modUpdateInfo.name + modUpdateInfo.currentVersion + modUpdateInfo.availableVersion;
		}
		this.m.ModUpdateHash = ::toHash(modsWithNewVersionsString);
		if (::MSU.Mod.PersistentData.hasFile("StoredModUpdates"))
		{
			local storedHash = ::MSU.Mod.PersistentData.readFile("StoredModUpdates");
			if (this.m.ModUpdateHash == storedHash) {
				return;
			}
		}
		this.m.JSHandle.asyncCall("showModUpdates", _modInfos);
	}

	function onNoUpdateReminder()
	{
		::MSU.Mod.PersistentData.createFile("StoredModUpdates", this.m.ModUpdateHash);
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
